#! /bin/sh -

PROGNAME=$0
option=$1

usage() {
  cat << EOF >&2
Usage $PROGNAME [-i] [-c]
  -i: Install config files
  -c: Clear/uninstall configs files
EOF
exit 1
}

CURR_DIR=`pwd`
case $option in
  (-c)
    echo "Uninstalling configs..."
    rm -rf $HOME/.vimrc $HOME/.config/nvim $HOME/.vim $HOME/.local/share/nvim $HOME/.config/coc
    ;;
  (-i)
    echo "Installing configs..."
    npm i -g import-js
    brew update && brew upgrade && brew install neovim watchman fzf bat git-delta the_silver_searcher
    $(brew --prefix)/opt/fzf/install
    mkdir -p $HOME/.config/nvim/{colors,plugged,spell,scripts,bundle}
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    git clone https://github.com/ctrlpvim/ctrlp.vim.git $HOME/.config/nvim/bundle/ctrlp.vim

    # Install Nerd Fonts
    brew tap homebrew/cask-fonts
    brew install font-hack-nerd-font

    mkdir -p $HOME/.vim/bundle
    git clone https://github.com/morhetz/gruvbox.git ~/.vim/bundle/gruvbox
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
    git clone https://github.com/tomasr/molokai.git $HOME/molokai && mv $HOME/molokai/colors/molokai.vim $HOME/.config/nvim/colors/molokai.vim && rm -rf $HOME/molokai

    ln -s $CURR_DIR/init.vim $HOME/.config/nvim/
    ln -s $CURR_DIR/coc-settings.json $HOME/.config/nvim/coc-settings.json
    # ln -s $CURR_DIR/.vimrc $HOME/.vimrc
    # ln -s $CURR_DIR/init.vim $HOME/.config/nvim/init.vim
    # ln -s $CURR_DIR/wrapwithtag.vim $HOME/.config/nvim/scripts/wrapwithtag.vim
    # nvim --headless +PluginInstall 'morhetz/gruvbox' +qall
    # nvim --headless +PlugInstall 'Yazeed1s/minimal.nvim' +qall
    # nvim --headless +PluginInstall +qall
    nvim --headless +PlugInstall +qall

    echo "Installation complete."
    ;;
  (*) usage
esac
shift "$((OPTIND - 1))"
