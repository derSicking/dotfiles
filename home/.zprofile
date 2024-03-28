if [ -z "$DISPLAY" ] && [ -z "$TMUX" ] && [ "$XDG_VTNR" = 1 ]; then
  eval `ssh-agent`
  ssh-add
	exec startx
fi
