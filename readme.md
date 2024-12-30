## eduuh's Nvim Config

### Debugging

1. C++ & C

2. Rust

3. JavaScript & Typescript

### Main Workflow Device (Mac)

1. Note Taking with Obsidian plugin.
2. Support for Mermaid rendering , Image pasting & Preview in NVIM.
   - This needs kitty terminal & magic

### Troubleshooting

- During installation, a large number of packages being downloaded from Mason and Lazy can sometimes create lockfiles. To resolve this, clear the contents of the `~/.local/share/nvim/` folder using the following command:

```bash
sudo rm -rf ~/.local/share/nvim/*
```

- After clearing the folder, open only one instance of Neovim and let the downloads complete:

```bash
nvim
```
