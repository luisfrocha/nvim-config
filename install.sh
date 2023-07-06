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
    rm -rf $HOME/.config/nvim
    ;;
  (-i)
    echo "Installing configs..."
    pnpm add -g neovim
    brew update && \
    brew upgrade && \
    brew tap homebrew/cask-fonts
    brew install \
      neovim \
      font-hack-nerd-font
    mkdir -p $HOME/.config
    ln -s $CURR_DIR $HOME/.config/nvim
    echo "Installation complete."
    ;;
  (*) usage
esac
shift "$((OPTIND - 1))"
