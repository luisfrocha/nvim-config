#! /bin/sh -

PROGNAME=$0
option=$1

# usage [exit_code]: print help and exit. Defaults to exit 1 (invalid usage,
# help to stderr); pass 0 for an explicit --help request (help to stdout).
usage() {
	code=${1:-1}
	msg=$(
		cat <<EOF
Usage $PROGNAME [-i|--install] [-u|--update] [-l|--link] [-x|--uninstall] [-h|--help]
  -i, --install:   Install config files and dependencies (fresh machine)
  -u, --update:    git pull, upgrade brew packages, and re-link
  -l, --link:      Re-link symlinks only (no git pull, no brew) — fast
  -x, --uninstall: Remove config symlinks
  -h, --help:      Show this help
EOF
	)
	if [ "$code" -eq 0 ]; then
		printf '%s\n' "$msg"
	else
		printf '%s\n' "$msg" >&2
	fi
	exit "$code"
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

# Symlink every entry of a repo source dir into a destination dir, then prune
# any stale links in the destination that point back into this repo but whose
# target no longer exists (so removing a file from the repo removes its link on
# the next run). Only touches links pointing into this repo — leaves unrelated
# items in the destination alone.
link_dir_contents() {
	src=$1
	dest=$2
	mkdir -p "$dest"
	for item in "$src"/*; do
		[ -e "$item" ] || continue
		ln -sfn "$item" "$dest/$(basename "$item")"
	done
	for link in "$dest"/*; do
		[ -L "$link" ] || continue
		case "$(readlink "$link")" in
		"$CURR_DIR"/*) [ -e "$link" ] || rm "$link" ;;
		esac
	done
}

# Remove every link in a destination dir that points back into this repo.
unlink_dir_contents() {
	dest=$1
	[ -d "$dest" ] || return 0
	for link in "$dest"/*; do
		[ -L "$link" ] || continue
		case "$(readlink "$link")" in
		"$CURR_DIR"/*) rm "$link" ;;
		esac
	done
}

link_configs() {
	mkdir -p "$HOME/.config"
	ln -sfn "$CURR_DIR/nvim" "$HOME/.config/nvim"
	ln -sfn "$CURR_DIR/ghostty" "$HOME/.config/ghostty"
	# Standalone personal scripts onto PATH (ensure ~/.local/bin is on your PATH).
	link_dir_contents "$CURR_DIR/bin" "$HOME/.local/bin"
	# Claude Code skills (kept in a visible, non-dotted dir so they show in Finder).
	link_dir_contents "$CURR_DIR/claude/skills" "$HOME/.claude/skills"
	# Skill-bundled scripts are also exposed on PATH so they're runnable directly
	# in a terminal, not only via the skill.
	for sdir in "$CURR_DIR"/claude/skills/*/scripts; do
		[ -d "$sdir" ] || continue
		link_dir_contents "$sdir" "$HOME/.local/bin"
	done
}

CURR_DIR=$(pwd)
case $option in
-x | --uninstall)
	echo "Uninstalling configs..."
	rm -rf "$HOME/.config/nvim"
	rm -rf "$HOME/.config/ghostty"
	unlink_dir_contents "$HOME/.local/bin"
	unlink_dir_contents "$HOME/.claude/skills"
	echo "Uninstall complete."
	;;
-i | --install)
	echo "Installing configs..."
	install_packages
	link_configs
	echo "Installation complete."
	;;
-u | --update)
	echo "Updating configs..."
	git pull
	install_packages
	link_configs
	echo "Update complete."
	;;
-l | --link)
	echo "Re-linking symlinks..."
	link_configs
	echo "Link complete."
	;;
-h | --help)
	usage 0
	;;
*) usage ;;
esac
