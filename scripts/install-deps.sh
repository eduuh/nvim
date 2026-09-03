#!/usr/bin/env bash
#
# Provision every dependency this Neovim config needs on a fresh machine.
#
# The config shells out to a handful of tools that neither vim.pack, lazy.nvim
# nor mason will install for you — most importantly the `tree-sitter` CLI, which
# tree-sitter-manager.nvim invokes to build every parser. Without it Neovim
# throws `ENOENT: ... 'tree-sitter'` on the first FileType event.
#
# Usage:
#   scripts/install-deps.sh              # install everything, then verify
#   scripts/install-deps.sh --check      # report what is missing, change nothing
#   scripts/install-deps.sh --skip-headless   # system deps only, no Neovim run
#   scripts/install-deps.sh --yes        # never prompt (CI)
#
# Supported: Debian/Ubuntu (apt) and macOS (Homebrew).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM_MIN="0.12.0"
LOCAL_BIN="${HOME}/.local/bin"

CHECK_ONLY=0
SKIP_HEADLESS=0
ASSUME_YES=0

# ─── output ──────────────────────────────────────────────────────────────────
if [ -t 1 ]; then
  C_RESET=$'\033[0m'; C_RED=$'\033[31m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'; C_DIM=$'\033[2m'
else
  C_RESET=; C_RED=; C_GREEN=; C_YELLOW=; C_BLUE=; C_DIM=
fi

step() { printf '\n%s==>%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
ok()   { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
bad()  { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$*"; }
note() { printf '  %s%s%s\n' "$C_DIM" "$*" "$C_RESET"; }
die()  { printf '\n%serror:%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# ─── args ────────────────────────────────────────────────────────────────────
while [ $# -gt 0 ]; do
  case "$1" in
    --check)         CHECK_ONLY=1 ;;
    --skip-headless) SKIP_HEADLESS=1 ;;
    -y|--yes)        ASSUME_YES=1 ;;
    -h|--help)       sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)               die "unknown argument: $1 (try --help)" ;;
  esac
  shift
done

confirm() {
  [ "$ASSUME_YES" -eq 1 ] && return 0
  [ -t 0 ] || return 0
  local reply
  read -r -p "  ${1} [Y/n] " reply
  [[ -z "$reply" || "$reply" =~ ^[Yy] ]]
}

# ─── platform ────────────────────────────────────────────────────────────────
case "$(uname -s)" in
  Linux)
    have apt-get || die "only Debian/Ubuntu (apt) and macOS (Homebrew) are supported"
    PLATFORM=apt
    ;;
  Darwin)
    have brew || die "Homebrew is required on macOS: https://brew.sh"
    PLATFORM=brew
    ;;
  *) die "unsupported OS: $(uname -s)" ;;
esac

SUDO=""
CAN_SUDO=1
if [ "$PLATFORM" = apt ] && [ "$(id -u)" -ne 0 ]; then
  if have sudo; then
    SUDO=sudo
    # An uncached sudo sits at a password prompt that expires on its own and
    # takes the whole run down with it. Every apt package here is optional, so
    # skip them and carry on to the required steps instead.
    sudo -n true 2>/dev/null || CAN_SUDO=0
  else
    CAN_SUDO=0
  fi
fi

SKIPPED_PACKAGES=()
APT_UPDATED=0
apt_install() {
  [ $# -eq 0 ] && return 0
  if [ "$APT_UPDATED" -eq 0 ]; then
    $SUDO apt-get update -qq || return 1
    APT_UPDATED=1
  fi
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y -qq "$@"
}

# ─── system packages ─────────────────────────────────────────────────────────
# Each entry is "command:apt-package:brew-formula". The command is what the
# config actually invokes; an empty package field means "not available here".
SYSTEM_PACKAGES=(
  "git:git:git"
  "curl:curl:curl"
  "unzip:unzip:unzip"
  "cc:build-essential:"          # treesitter parsers + LuaSnip jsregexp
  "make:build-essential:"        # LuaSnip jsregexp
  "cmake:cmake:cmake"            # cmake-tools.nvim
  "rg:ripgrep:ripgrep"           # fzf-lua live grep
  "fzf:fzf:fzf"                  # fzf-lua binary
  "fdfind:fd-find:fd"            # fzf-lua file listing (aliased to fd below)
  "shfmt:shfmt:shfmt"            # conform sh formatter
  "clangd:clangd:llvm"           # clangd_extensions.nvim
  "clang-format:clang-format:clang-format"
  "lldb:lldb:llvm"               # rustaceanvim / codelldb
  "python3:python3:python3"
  "lazygit::jesseduffield/lazygit/lazygit"
)

field() { printf '%s' "$1" | cut -d: -f"$2"; }

install_system_packages() {
  step "System packages ($PLATFORM)"
  local missing_pkgs=() entry cmd pkg

  for entry in "${SYSTEM_PACKAGES[@]}"; do
    cmd="$(field "$entry" 1)"
    if [ "$PLATFORM" = apt ]; then pkg="$(field "$entry" 2)"; else pkg="$(field "$entry" 3)"; fi

    if have "$cmd"; then
      ok "$cmd"
      continue
    fi
    if [ -z "$pkg" ]; then
      warn "$cmd is missing and has no package on $PLATFORM — install it manually"
      continue
    fi
    bad "$cmd (provided by $pkg)"
    missing_pkgs+=("$pkg")
  done

  # De-duplicate (build-essential backs several commands).
  if [ ${#missing_pkgs[@]} -gt 0 ]; then
    mapfile -t missing_pkgs < <(printf '%s\n' "${missing_pkgs[@]}" | sort -u)
  fi

  if [ ${#missing_pkgs[@]} -eq 0 ]; then
    ok "nothing to install"
    return 0
  fi
  if [ "$CHECK_ONLY" -eq 1 ]; then
    note "would install: ${missing_pkgs[*]}"
    return 0
  fi

  if [ "$PLATFORM" = apt ] && [ "$CAN_SUDO" -eq 0 ]; then
    warn "sudo is not available without a password prompt — skipping apt packages"
    note "run 'sudo -v' and re-run this script to install: ${missing_pkgs[*]}"
    SKIPPED_PACKAGES=("${missing_pkgs[@]}")
    return 0
  fi

  confirm "Install ${missing_pkgs[*]}?" || { warn "skipped by request"; return 0; }

  # These are all optional tools; a failure here must not stop the required
  # steps (tree-sitter CLI, parsers, mason) that follow.
  if [ "$PLATFORM" = apt ]; then
    apt_install "${missing_pkgs[@]}" || warn "apt install failed — continuing"
  else
    brew install "${missing_pkgs[@]}" || warn "brew install failed — continuing"
  fi
}

# mason installs several tools (clang-format among them) from PyPI, which needs a
# working venv. Debian splits ensurepip out into python3-venv, and without it
# those packages fail with "ensurepip is not available".
ensure_python_venv() {
  step "Python venv (mason's PyPI-based tools)"
  if python3 -c "import ensurepip" >/dev/null 2>&1; then
    ok "ensurepip available"
    return 0
  fi
  bad "ensurepip is missing — mason cannot install its PyPI packages"
  if [ "$CHECK_ONLY" -eq 1 ]; then note "would install python3-venv"; return 0; fi
  if [ "$PLATFORM" != apt ]; then
    warn "install a Python with venv support and re-run"
    return 0
  fi
  if [ "$CAN_SUDO" -eq 0 ]; then
    warn "sudo unavailable — skipping python3-venv"
    SKIPPED_PACKAGES+=("python3-venv")
    return 0
  fi
  apt_install python3-venv || { warn "python3-venv install failed — continuing"; return 0; }
  python3 -c "import ensurepip" >/dev/null 2>&1 && ok "ensurepip available" \
    || warn "ensurepip still unavailable"
}

# Debian ships fd as `fdfind`; fzf-lua looks for `fd`.
link_fd() {
  have fd && { ok "fd"; return 0; }
  have fdfind || return 0
  [ "$CHECK_ONLY" -eq 1 ] && { note "would link fdfind -> $LOCAL_BIN/fd"; return 0; }
  mkdir -p "$LOCAL_BIN"
  ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
  ok "linked fdfind -> $LOCAL_BIN/fd"
}

# ─── language toolchains ─────────────────────────────────────────────────────
load_nvm() {
  # shellcheck disable=SC1091
  [ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ] && . "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
}

ensure_node() {
  step "Node.js (magenta.nvim, typescript-language-server, prettier, js-debug-adapter)"
  load_nvm || true
  if have node && have npm; then
    ok "node $(node --version)"
    ok "npm $(npm --version)"
    return 0
  fi
  if [ "$CHECK_ONLY" -eq 1 ]; then bad "node/npm missing — would install via nvm"; return 0; fi

  confirm "Install Node.js LTS via nvm?" || die "aborted (node is required)"
  if [ ! -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi
  load_nvm
  nvm install --lts
  nvm alias default 'lts/*'
  have node || die "node still not on PATH after nvm install"
  ok "node $(node --version)"
}

ensure_rust() {
  step "Rust (rustaceanvim, rustfmt)"
  [ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  if have cargo && have rustc; then
    ok "rustc $(rustc --version | awk '{print $2}')"
    have rust-analyzer || note "rust-analyzer comes from rustup: rustup component add rust-analyzer"
    return 0
  fi
  if [ "$CHECK_ONLY" -eq 1 ]; then bad "cargo/rustc missing — would install via rustup"; return 0; fi

  if confirm "Install Rust via rustup?"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    . "$HOME/.cargo/env"
    rustup component add rust-analyzer rustfmt clippy
    ok "rustc $(rustc --version | awk '{print $2}')"
  else
    warn "skipping Rust — rust files will have no LSP or formatter"
  fi
}

# ─── Neovim ──────────────────────────────────────────────────────────────────
version_lt() { [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" = "$1" ] && [ "$1" != "$2" ]; }

ensure_neovim() {
  step "Neovim >= $NVIM_MIN"
  local current=""
  have nvim && current="$(nvim --version | head -1 | sed 's/^NVIM v//')"

  if [ -n "$current" ] && ! version_lt "$current" "$NVIM_MIN"; then
    ok "nvim $current"
    return 0
  fi
  if [ -z "$current" ]; then bad "nvim is not installed"; else bad "nvim $current is older than $NVIM_MIN"; fi
  if [ "$CHECK_ONLY" -eq 1 ]; then note "would install the latest stable Neovim"; return 0; fi

  confirm "Install the latest stable Neovim?" || die "aborted (Neovim >= $NVIM_MIN is required)"

  if [ "$PLATFORM" = brew ]; then
    brew install neovim
  else
    # Ubuntu's archive lags well behind 0.12, so take the official tarball.
    local arch asset tmp
    case "$(uname -m)" in
      x86_64)         arch=x86_64 ;;
      aarch64|arm64)  arch=arm64 ;;
      *) die "no official Neovim tarball for $(uname -m) — build from source" ;;
    esac
    asset="nvim-linux-${arch}.tar.gz"
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' RETURN
    curl -fsSL -o "$tmp/$asset" \
      "https://github.com/neovim/neovim/releases/latest/download/$asset"
    mkdir -p "$HOME/.local"
    tar -xzf "$tmp/$asset" -C "$tmp"
    rm -rf "$HOME/.local/nvim"
    mv "$tmp/nvim-linux-${arch}" "$HOME/.local/nvim"
    mkdir -p "$LOCAL_BIN"
    ln -sf "$HOME/.local/nvim/bin/nvim" "$LOCAL_BIN/nvim"
    note "installed to $HOME/.local/nvim, linked at $LOCAL_BIN/nvim"
  fi
  hash -r
  ok "nvim $(nvim --version | head -1 | sed 's/^NVIM v//')"
}

# ─── tree-sitter CLI ─────────────────────────────────────────────────────────
# tree-sitter-manager.nvim runs `tree-sitter build` for every parser in
# ensure_installed. This is the dependency whose absence crashes startup.
ensure_tree_sitter_cli() {
  step "tree-sitter CLI (required by tree-sitter-manager.nvim)"
  if have tree-sitter; then
    ok "tree-sitter $(tree-sitter --version | awk '{print $2}')"
    return 0
  fi
  bad "tree-sitter is missing — every parser build will fail"
  if [ "$CHECK_ONLY" -eq 1 ]; then note "would install tree-sitter-cli via npm"; return 0; fi

  load_nvm || true
  have npm || die "npm is required to install the tree-sitter CLI"
  confirm "Install tree-sitter-cli globally via npm?" || die "aborted (the CLI is required)"
  npm install -g tree-sitter-cli
  hash -r
  have tree-sitter || die "tree-sitter still not on PATH — check that npm's global bin is in PATH"
  ok "tree-sitter $(tree-sitter --version | awk '{print $2}')"
}

# ─── headless Neovim provisioning ────────────────────────────────────────────
run_headless_bootstrap() {
  step "Neovim plugin, parser and tool install (headless)"
  if [ "$SKIP_HEADLESS" -eq 1 ]; then note "skipped (--skip-headless)"; return 0; fi
  if [ "$CHECK_ONLY" -eq 1 ]; then note "would run scripts/bootstrap.lua under headless Neovim"; return 0; fi

  load_nvm || true
  [ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  note "this clones plugins and compiles every parser — it takes a few minutes"

  # bootstrap.lua must be sourced during startup so its mason autocmd is
  # registered before mason-tool-installer's deferred run fires.
  local active_config
  active_config="$(readlink -f "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" 2>/dev/null || true)"

  if [ "$active_config" = "$REPO_ROOT" ]; then
    nvim --headless -c "luafile $REPO_ROOT/scripts/bootstrap.lua"
  else
    # `nvim -u <file>` does not put the repo on the runtimepath, so point
    # XDG_CONFIG_HOME at a throwaway dir whose nvim/ links to this checkout.
    note "$HOME/.config/nvim does not point at this repo — using a temporary config shim"
    local shim
    shim="$(mktemp -d)"
    ln -s "$REPO_ROOT" "$shim/nvim"
    XDG_CONFIG_HOME="$shim" nvim --headless -c "luafile $REPO_ROOT/scripts/bootstrap.lua"
    local rc=$?
    rm -rf "$shim"
    return $rc
  fi
}

# ─── summary ─────────────────────────────────────────────────────────────────
REQUIRED=(nvim git curl node npm tree-sitter cc make)
OPTIONAL=(rg fzf fd cmake shfmt clangd clang-format lldb cargo lazygit python3)

report() {
  step "Summary"
  local missing=0 cmd
  for cmd in "${REQUIRED[@]}"; do
    if have "$cmd"; then ok "$cmd"; else bad "$cmd (required)"; missing=$((missing + 1)); fi
  done
  for cmd in "${OPTIONAL[@]}"; do
    if have "$cmd"; then ok "$cmd"; else warn "$cmd (optional)"; fi
  done

  if [ "$missing" -gt 0 ]; then
    printf '\n%s%d required dependenc%s still missing.%s\n' \
      "$C_RED" "$missing" "$([ "$missing" -eq 1 ] && echo y || echo ies)" "$C_RESET"
    return 1
  fi
  if [ ${#SKIPPED_PACKAGES[@]} -gt 0 ]; then
    printf '\n%sSkipped (needs sudo):%s %s\n' "$C_YELLOW" "$C_RESET" "${SKIPPED_PACKAGES[*]}"
    note "run 'sudo -v', then re-run this script"
  fi
  printf '\n%sAll required dependencies are present.%s\n' "$C_GREEN" "$C_RESET"
}

# ─── main ────────────────────────────────────────────────────────────────────
printf '%sNeovim dependency installer%s  (%s)\n' "$C_BLUE" "$C_RESET" "$REPO_ROOT"
[ "$CHECK_ONLY" -eq 1 ] && note "check mode — nothing will be installed"

install_system_packages
ensure_python_venv
link_fd
ensure_node
ensure_rust
ensure_neovim
ensure_tree_sitter_cli
run_headless_bootstrap
report
