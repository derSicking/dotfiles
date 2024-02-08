if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  eval `ssh-agent`
  ssh-add
	exec startx
fi
