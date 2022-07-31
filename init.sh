#!/bin/bash

CURR_DIR=`pwd`
while getopts ":c" option;
do
	case $option in
		c)
			echo "Uninstalling configs..."
			rm -rf $HOME/.vimrc $HOME/.config/nvim
			;;
        ?) 
			mkdir -p $HOME/.config/nvim/{colors,plugged,spell}
            mkdir -p $HOME/.vim/bundle
            git clone https://github.com/morhetz/gruvbox.git ~/.vim/bundle/gruvbox
            git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
            git clone https://github.com/tomasr/molokai.git $HOME/molokai
			ln -s $CURR_DIR/init.vim $HOME/.config/nvim/init.vim
			ln -s $CURR_DIR/coc-settings.json $HOME/.config/nvim/coc-settings.json
			ln -s $CURR_DIR/.vimrc $HOME/.vimrc
            mv $HOME/molokai/colors/molokai.vim $HOME/.config/nvim/colors/molokai.vim
            rm -rf $HOME/molokai
#            nvim --headless +PluginInstall 'morhetz/gruvbox' +qall
#            nvim --headless +PlugInstall 'Yazeed1s/minimal.nvim' +qall
			nvim --headless +PlugInstall +qall
			nvim --headless +PluginInstall +qall
			;;
	esac
done
