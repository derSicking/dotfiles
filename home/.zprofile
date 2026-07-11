source $HOME/.path

export EDITOR='nvim'

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$TMUX" ] && [ "$XDG_VTNR" = 1 ]; then
  eval `ssh-agent`
  ssh-add
	exec sway
fi
