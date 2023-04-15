Mis archivos de configuración
=============================

## Dependencias

- vim-plug: https://github.com/junegunn/vim-plug
- https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting#fonts
- Devicons: https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-1000-em%20Nerd%20Font%20Complete.ttf

## Ubuntu
```sh
$ sudo add-apt-repository ppa:neovim-ppa/unstable
$ sudo apt install neovim rubygems fzf tmux xclip neovim python3-neovim python3-pip nodejs ripgrep xdg-utils wslu
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


# Instalar plugins de forma no interactiva
$ nvim --headless +PlugInstall +qall
```
