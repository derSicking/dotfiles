alias __eza_long="eza --long --git --no-quotes --icons=always"
alias __eza_long_all="__eza_long -a"
alias __eza_long_concise="__eza_long --no-filesize --no-user --no-permissions --git-ignore"
alias __eza_long_tree="__eza_long_concise --tree"

alias ls="__eza_long_concise"
alias la="__eza_long_all"

alias lt="__eza_long_tree"
alias lt1="__eza_long_tree -L=1"
alias lt2="__eza_long_tree -L=2"
alias lt3="__eza_long_tree -L=3"
alias lt4="__eza_long_tree -L=4"
alias lt5="__eza_long_tree -L=5"

alias tree="__eza_long_tree"
