source $HOME/.path

export PROTON_ENABLE_WAYLAND=1
export WAYLANDDRV_PRIMARY_MONITOR=DP-2 

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$TMUX" ] && [ "$XDG_VTNR" = 1 ]; then
  eval `ssh-agent`
  ssh-add
	exec sway
fi
