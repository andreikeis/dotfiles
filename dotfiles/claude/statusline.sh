#!/bin/sh
# Claude Code status line: [☁ devbox] dir  branch · model
# Remote badge appears only when DEVBOX_LABEL is set (zshrc/bashrc export it on
# SSH/EC2 hosts), in the same Solarized orange as the starship prompt and tmux.
input=$(cat)
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null)

esc=$(printf '\033')
badge=""
[ -n "$DEVBOX_LABEL" ] && badge="${esc}[1;38;2;253;246;227;48;2;203;75;22m ☁ ${DEVBOX_LABEL} ${esc}[0m "

short_dir=$(printf '%s' "$dir" | sed "s|^$HOME|~|")
printf '%s%s[1;36m%s%s[0m' "$badge" "$esc" "$short_dir" "$esc"
[ -n "$branch" ] && printf ' %s[1;35m %s%s[0m' "$esc" "$branch" "$esc"
[ -n "$model" ] && printf ' %s[2m· %s%s[0m' "$esc" "$model" "$esc"
