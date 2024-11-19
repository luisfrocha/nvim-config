#! /bin/sh -

PROGNAME=$0
option=$1

usage() {
	cat <<EOF >&2
Usage $PROGNAME [-i] [-c]
  -i: Install config files
  -c: Clear/uninstall configs files
EOF
	exit 1
}

CURR_DIR=$(pwd)
case $option in
-c)
	echo "Uninstalling configs..."
	rm -rf $HOME/.config/nvim
	LAZYGIT_VAR="CONFIG_DIR"
	LINE_NUMBER=$(cat ~/.zshrc | grep -n "${LAZYGIT_VAR}" | cut -d : -f 1)
	if [ -n "${LINE_NUMBER+1}" ]; then
		sed -i.bkp "${LINE_NUMBER}d" ~/.zshrc
	fi
	;;
-i)
	echo "Installing configs..."
	pnpm add -g neovim prettier typescript-language-server typescript
	brew update &&
		brew upgrade &&
		brew tap homebrew/cask-fonts
	brew tap jesseduffield/lazygit
	brew install \
		neovim \
		font-hack-nerd-font \
		ctags \
		git-flow-avh \
		lazygit \
		fd \
		fzf \
		gh \
		neovide \
		hg \
		wget \
		luarocks \
		php \
		composer
	$(brew --prefix)/opt/fzf/install
	mkdir -p $HOME/.config
	ln -s $CURR_DIR $HOME/.config/nvim
	# cp -r $CURR_DIR/NeovideLauncher.app ~/Applications/
	export CONFIG_DIR="$HOME/.config/nvim/lazygit"
	echo 'export CONFIG_DIR="$HOME/.config/nvim/lazygit"' >>~/.zshrc
	echo "Installation complete."
	;;
*) usage ;;
esac
shift "$((OPTIND - 1))"
