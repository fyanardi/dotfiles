#!/bin/sh

cp -r .config ~
cp .bash_aliases ~

# Git setup
git config --global user.name "Fredy Yanardi"
git config --global user.email "fyanardi@gmail.com"
git config --global core.editor nvim

# Additional Neovim setup
## install Nerd Font referenced by the configuration - adapted from https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0
mkdir -p ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip -O ~/Downloads/FiraCode.zip
mkdir -p ~/.fonts
unzip ~/Downloads/FiraCode.zip -d ~/.fonts
fc-cache -fv

# Install global NPM packages into user's local directory
npm config set prefix '~/.local/'
