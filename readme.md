### My Neovim and Vscode Integrations

## Install in One command.

The following will install the config if you have an existing config it will movit it to **~/.config/nvim.old**

This script only support **Arch Ubuntu**.

## Install Neovim

1. Ubuntu

```
sudo apt install neovim
```

2. Arch

```

sudo pacman -S neovim
yay -S neovim-git # Latest

```

## Clone this repo into your config.

```
git clone https://github.com/eduuh/nvim.git

```

## Install python and Node Support

<hr>

```
pit install pynvim
```

````
npm -i -g neovim

## Install Neovim remote.

```
pip install neovim-remote
````

👆 This will install nvr to **~/.local/bin** so you will need to add the following to your **bashrc** or **zshrc**

```
export PATH=$HOME/.local/bin:$PATH
```

### Install clipboard support.

1. Arch

```
sudo pacman -S xsel
```

2. Ubuntu

```
sudo apt install xsel
```
### Program to Look into the future

- ueberzug
- silver_searcher
- fd
- universal-ctags
- lazy git
- lazy docker.

## ToDo

- Look at __neovim remote__ and even try out with vms on azure.
- look at Vim gists
- better config

### Vscode and Neo Vim Extension.

[The neo vim Extension]() is available in the VSCODE marketplace. Use it alongside the VSCODE __which-key__ extension.
```
