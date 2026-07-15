Mis archivos de configuración
=============================

## Dependencias

- [lazy.nvim](https://github.com/folke/lazy.nvim) — gestor de plugins (autoinstalado al primer arranque)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — parsers para syntax highlighting
  - Requiere compilador C: `build-essential` (Ubuntu) / `gcc-c++` (Fedora)
- [Devicons](https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-1000-em%20Nerd%20Font%20Complete.ttf) — iconos opcionales (requiere fuente Nerd Font)

> Requiere Neovim >= 0.9 (recomendado 0.10+, se usa Lua nativo y treesitter runtime).

## Ubuntu
```sh
$ sudo add-apt-repository ppa:neovim-ppa/unstable
$ sudo apt install neovim rubygems fzf tmux xclip neovim python3-neovim python3-pip nodejs ripgrep xdg-utils wslu build-essential
$ pip install dotbot
$ sudo gem install tmuxinator


```
## Fedora
```sh
$ sudo dnf copr enable agriffis/neovim-nightly
$ sudo dnf install rubygems fzf tmux xclip neovim python3-neovim nodejs ripgrep gcc-c++
$ gem install tmuxinator

```

## Instalación

```sh
# Generar llave ssh
ls -al ~/.ssh
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
xclip -selection clipboard < ~/.ssh/id_ed25519.pub
cat ~/.ssh/id_ed25519.pub

# Pegarla en ssh y gpg keys de github https://github.com/settings/keys

# Clonar repositorio
git clone git@github.com:adrian-martinez-dev/dotfiles.git && cd ~/dotfiles && ~/.local/bin/dotbot -c install.conf.yaml


# Instalar/sincronizar plugins de forma no interactiva (lazy.nvim)
$ nvim --headless "+Lazy! sync" +qa
```

## Estructura

- `init.lua` — configuración de Neovim en Lua (antes `nvimrc` en Vimscript).
  Organizado por secciones: Options, Autocommands, Keymaps, Plugins, etc.
- `lazy-lock.json` — versionado de plugins gestionados por lazy.nvim.
- `install.conf.yaml` — manifiesto de Dotbot para crear symlinks.
- `gnvimrc` — configuración de la GUI de Neovim (ginit.vim).
```
