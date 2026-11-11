#! /bin/sh -

PROGNAME=$0
option=$1

# usage [exit_code]: print help and exit. Defaults to exit 1 (invalid usage,
# help to stderr); pass 0 for an explicit --help request (help to stdout).
usage() {
	code=${1:-1}
	msg=$(
		cat <<EOF
Usage $PROGNAME [-i|--install] [-u|--update] [-l|--link] [-x|--uninstall] [-h|--help] [personal|work]
  -i, --install:   Install config files and dependencies (fresh machine)
  -u, --update:    git pull, upgrade brew packages, and re-link
  -l, --link:      Re-link symlinks only (no git pull, no brew) — fast
  -x, --uninstall: Remove config symlinks
  -h, --help:      Show this help

  [personal|work]: Obsidian profile for this machine (-i/-u/-l only). Only
                    needed once — remembered in ~/.config/obsidian-profile
                    after that.
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
		git-flow \
		jq
	brew install --cask \
		font-hack-nerd-font \
		font-victor-mono-nerd-font \
		supacode \
		obsidian
	"$(brew --prefix)/opt/fzf/install"
	pnpm add -g neovim prettier
}

OBSIDIAN_PROFILE_FILE="$HOME/.config/obsidian-profile"
OBSIDIAN_CONFIG_REPO="git@github.com:luisfrocha/obsidian-config.git"
OBSIDIAN_CONFIG_DIR="$HOME/Sites/obsidian-config"

# Clone/pull the shared Obsidian settings repo and link it into this
# machine's personal or work vault. Profile is passed in on first run and
# then remembered in $OBSIDIAN_PROFILE_FILE so later -u/-l calls don't need
# it again.
setup_obsidian() {
	profile=$1
	do_pull=$2
	if [ -z "$profile" ] && [ -f "$OBSIDIAN_PROFILE_FILE" ]; then
		profile=$(cat "$OBSIDIAN_PROFILE_FILE")
	fi
	if [ -z "$profile" ]; then
		echo "No Obsidian profile set yet — skipping. Re-run with: $PROGNAME $option personal|work" >&2
		return 0
	fi
	case "$profile" in
	personal | work) : ;;
	*)
		echo "Unknown Obsidian profile '$profile' (expected personal|work)" >&2
		return 1
		;;
	esac
	mkdir -p "$HOME/.config"
	printf '%s' "$profile" >"$OBSIDIAN_PROFILE_FILE"

	if [ -d "$OBSIDIAN_CONFIG_DIR/.git" ]; then
		[ "$do_pull" = "yes" ] && (cd "$OBSIDIAN_CONFIG_DIR" && git pull)
	elif [ "$do_pull" = "yes" ]; then
		git clone "$OBSIDIAN_CONFIG_REPO" "$OBSIDIAN_CONFIG_DIR"
	else
		echo "obsidian-config not cloned yet — run $PROGNAME -i $profile first" >&2
		return 1
	fi

	vault="$HOME/Sites/${profile}-vault"
	mkdir -p "$vault"
	"$OBSIDIAN_CONFIG_DIR/install.sh" "$vault"
	link_obsidian_skills_plugin
}

# Declare the kepano/obsidian-skills marketplace + plugin in
# ~/.claude/settings.json (merged in with jq so unrelated settings like
# "model" survive). This is the documented non-interactive equivalent of
# running `/plugin marketplace add` + `/plugin install` by hand — same keys
# Claude Code itself writes when you run those interactively.
link_obsidian_skills_plugin() {
	settings="$HOME/.claude/settings.json"
	mkdir -p "$HOME/.claude"
	[ -f "$settings" ] || echo '{}' >"$settings"
	tmp=$(mktemp)
	jq '.extraKnownMarketplaces["obsidian-skills"] = {"source": {"source": "github", "repo": "kepano/obsidian-skills"}}
		| .enabledPlugins["obsidian@obsidian-skills"] = true' \
		"$settings" >"$tmp" && mv "$tmp" "$settings"
	echo "Declared obsidian-skills plugin in $settings."
	echo "If Claude Code doesn't pick it up on next launch, run this once in a Claude Code session:"
	echo "  /plugin marketplace add kepano/obsidian-skills"
	echo "  /plugin install obsidian@obsidian-skills"
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
	setup_obsidian "$2" yes
	echo "Installation complete."
	;;
-u | --update)
	echo "Updating configs..."
	git pull
	install_packages
	link_configs
	setup_obsidian "$2" yes
	echo "Update complete."
	;;
-l | --link)
	echo "Re-linking symlinks..."
	link_configs
	setup_obsidian "$2" no
	echo "Link complete."
	;;
-h | --help)
	usage 0
	;;
*) usage ;;
esac
