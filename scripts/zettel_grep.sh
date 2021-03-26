#!/bin/sh
set -u
set -e

readonly WIKI_DIR=`echo ${WIKI}`

if [[ ! -a "${WIKI_DIR}" ]]; then
	echo "empty" >> "${WIKI_DIR}"
fi

function get_notes()
{
	cd ${WIKI_DIR}
	rg -n -tmd "^#."
}

function main()
{
	local all_notes="$(get_notes)"
	local note=$( (echo "${all_notes}")| rofi -dmenu -i -matching fuzzy -sorting-method fzf -sort -theme themes/zettel_grep_menu.rasi -p "Note")
	if [[ -n "${note}" ]]; then
		local matching=$( (echo "${all_notes}") | rg -n "^${note}$")
		note=`echo $note | cut -d':' -f 1`
		if [[ -n "${matching}" ]]; then
			tmux new-window -n "zettel"
			tmux send-keys "nvim --cmd 'set autochdir' '${WIKI_DIR}/${note}'" C-m
		else
			local now="$(date +'%Y%m%d%H%M%S')"
			local clear=`echo $note | sed 's/[[:blank:]]*$//'`
			local filename="${WIKI_DIR}/${now}-${clear// /_}.md"
			tmux new-window -n "${clear// /_}"
			tmux send-keys "nvim --cmd 'set autochdir' '${filename}'" C-m
		fi
			local i3="i3-msg 'workspace number 1'"
			eval $i3
	fi
}

main
