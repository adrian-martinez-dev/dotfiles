Mis archivos de configuración
=============================

## Dependencias

- vim-plug: https://github.com/junegunn/vim-plug
- https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting#fonts
- Devicons: https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-1000-em%20Nerd%20Font%20Complete.ttf

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

# Pegarla en ssh y gpg keys de github https://github.com/settings/keys

# Clonar repositorio
git clone git@github.com:nbicalcarata/dotfiles.git && cd ~/dotfiles && ./install

# Instalar plugins de forma no interactiva
$ nvim --headless +PlugInstall +qall
```
