#!/bin/bash

set -e

# setup bash profile
echo -e "Installing bash profile.\\n"
cp bash_profile ~/.profile

# setup inputrc so we can do vi mode in tmux and still be able to clear with Ctrl-l
echo -e "Install inputrc configuration to fix ctrl-l in tmux\\n"
cp inputrc ~/.inputrc

# install brew
echo -e "Installing vim, git, tmux, and mpw\\n"
brew install vim git tmux mpw

# close vimrc
echo -e "cloning https://github.com/amix/vimrc.git\\n"
git clone https://github.com/amix/vimrc.git ~/.vim_runtime

# install vimrc
echo -e "Running amix/vimrc install_awesome_vimrc.sh script.\\n"
sh ~/.vim_runtime/install_awesome_vimrc.sh

# install personal changes to vimrc
echo -e "Installing personalized settings for vim config.\\n"
cp my_configs.vim ~/.vim_runtime/my_configs.vim

# vim-terraform
echo -e "Cloning vim-terraform.\\n"
git clone https://github.com/hashivim/vim-terraform.git ~/.vim_runtime/sources_non_forked

# install tmux config
echo -e "Installing tmux configuration.\\n"
cp -R tmux ~/.tmux
cp tmux.conf ~/.tmux.conf

# install qutebrowser config (browser needs to be installed.)
echo -e "Installing qutebrowser config into ~/.qutebrowser\\nYou'll need to still download qutebrower.\\n"
cp -R qutebrowser ~/.qutebrowser

echo -e "Now execute the folllwing:\\n\\tsource ~/.profile\\n or restart terminal session.\\n"
# TODO items list.
echo -e "\\n\\nTODO:\\n\\tInstall\\n\\t- terraform\\n\\t- mpw\\n\\t- qutebrowser\\n\\t- iterm2\\n\\t- keybase\\n\\t- vlc\\n\\t- goland\\n\\t- atom\\n\\t- chrome\\n\\t- littlesnitch\\n\\t- gpgtools"
