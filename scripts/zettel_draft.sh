#!/bin/sh
set -u
set -e

readonly DIRECTORY=$(echo $WIKI)/drafts

if [[ ! -a "${DIRECTORY}" ]]; then
	echo "empty" >> "${DIRECTORY}"
fi

function get_notes()
{
	cd ${DIRECTORY}
	rg -l -tmd ""
}

function main()
{
	local all_notes="$(get_notes)"
	local note=$( (echo "${all_notes}")| rofi -dmenu -i -matching fuzzy -sorting-method fzf -sort -theme themes/zettel_draft.rasi -p "Draft")
	if [[ -n "${note}" ]]; then
		local matching=$( (echo "${all_notes}") | rg -l "^${note}$")
		if [[ -n "${matching}" ]]; then
			tmux new-window -n "${note}"
			tmux send-keys "nvim --cmd 'set autochdir' '${DIRECTORY}/${note}'" C-m
		else
			local now="$(date +'%Y%m%d%H%M%S')"
			local clear=`echo $note | sed 's/[[:blank:]]*$//'`
			local filename="${DIRECTORY}/${now}-${clear// /_}.md"
			tmux new-window -n "${clear// /_}"
			tmux send-keys "nvim --cmd 'set autochdir' '${filename}'" C-m
		fi
		local i3="i3-msg 'workspace number 1'"
		eval $i3
	fi
}

main
