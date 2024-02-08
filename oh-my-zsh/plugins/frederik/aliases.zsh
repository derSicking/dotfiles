nvim-dir() {
  if [ "$#" -eq 1 ] && [ -d "$1" ]; then
    /usr/bin/nvim +"cd $1" "$1"
  else
    /usr/bin/nvim $@
  fi
}

alias nvim="nvim-dir"
alias vim="nvim-dir"
alias vi="nvim-dir"
alias v="nvim-dir"

alias nvim.="nvim-dir ."
alias vim.="nvim-dir ."
alias vi.="nvim-dir ."
alias v.="nvim-dir ."

__get_tmux_name() {
  readlink -f "$1" | tr .: _
}

__tmux_nvim_named() {
  if /usr/bin/tmux has-session -t "$2"; then
    /usr/bin/tmux attach -t "$2"
  else
    /usr/bin/tmux new-session -s "$2" -c "$1" -d
    /usr/bin/tmux send-keys -t "$2" "nvim-dir "$(readlink -f "$1")"" Enter
    /usr/bin/tmux attach -t "$2"
  fi
}

tmux-nvim() {
  if [ "$#" -eq 1 ] && [ -d "$1" ]; then
    __tmux_nvim_named "$1" "$(__get_tmux_name "$1")"
  elif [ "$#" -eq 2 ] && [ -d "$1" ]; then
    __tmux_nvim_named "$1" "$2"
  elif [ "$#" -eq 0 ]; then
    tmux-nvim .
  fi
}

alias tnvim="tmux-nvim"
alias tvim="tmux-nvim"
alias tvi="tmux-nvim"
alias tv="tmux-nvim"

DOT=$HOME/.dotfiles

alias configure-nvim="nvim-dir $DOT/config/nvim/"
alias configure-zsh="nvim-dir $DOT/oh-my-zsh/plugins/frederik/"
alias configure-i3="nvim-dir $DOT/config/i3/config"
alias configure-alacritty="nvim-dir $DOT/config/alacritty/alacritty.toml"
alias configure-tmux="nvim-dir $DOT/config/tmux/tmux.conf"
alias configure-dotfiles="nvim-dir $HOME/.dotfiles"

alias :q="exit"

alias clr="clear"
alias claer="clear"
