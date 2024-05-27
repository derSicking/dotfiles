alias nvim="nvim-dir"
alias vim="nvim-dir"
alias vi="nvim-dir"
alias v="nvim-dir"

alias nvim.="nvim-dir ."
alias vim.="nvim-dir ."
alias vi.="nvim-dir ."
alias v.="nvim-dir ."

alias sudo-nvim="sudo -E nvim"
alias sv="sudo-nvim"

alias tnvim="tmux-nvim"
alias tvim="tmux-nvim"
alias tvi="tmux-nvim"
alias tv="tmux-nvim"

alias t="tmux"
alias ta="tmux a"
alias tk="tmux kill-server"

DOT=$HOME/.dotfiles

alias configure-nvim="tmux-nvim $DOT/config/nvim/"
alias configure-zsh="tmux-nvim $DOT/oh-my-zsh/plugins/frederik/"
alias configure-i3="tmux-nvim $DOT/config/i3"
alias configure-alacritty="nvim-dir $DOT/config/alacritty/alacritty.toml"
alias configure-tmux="tmux-nvim $DOT/config/tmux/"
alias configure-dotfiles="tmux-nvim $HOME/.dotfiles"

alias :q="exit"

alias clr="clear"
alias claer="clear"
