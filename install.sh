#! /bin/sh -

PROGNAME=$0
option=$1

usage() {
	cat <<EOF >&2
Usage $PROGNAME [-i] [-u] [-c]
  -i: Install config files and dependencies (fresh machine)
  -u: Update config files and brew packages
  -c: Clear/uninstall config symlinks
EOF
	exit 1
}

install_packages() {
	brew update && brew upgrade
	brew install \
		neovim \
		neovide \
		fd \
		fzf \
		ripgrep \
		gh \
		tree-sitter \
		git-delta \
		eza \
		nvm \
		pnpm \
		luarocks \
		git-flow
	brew install --cask \
		font-hack-nerd-font \
		font-victor-mono-nerd-font \
		supacode
	"$(brew --prefix)/opt/fzf/install"
	pnpm add -g neovim prettier
}

link_configs() {
	mkdir -p "$HOME/.config"
	ln -sfn "$CURR_DIR/nvim" "$HOME/.config/nvim"
	ln -sfn "$CURR_DIR/ghostty" "$HOME/.config/ghostty"
}

CURR_DIR=$(pwd)
case $option in
-c)
	echo "Uninstalling configs..."
	rm -rf "$HOME/.config/nvim"
	rm -rf "$HOME/.config/ghostty"
	;;
-i)
	echo "Installing configs..."
	install_packages
	link_configs
	echo "Installation complete."
	;;
-u)
	echo "Updating configs..."
	git pull
	install_packages
	link_configs
	echo "Update complete."
	;;
*) usage ;;
esac
shift "$((OPTIND - 1))"
