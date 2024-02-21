fish_vi_key_bindings

set -gx EDITOR nvim
set -gx fish_prompt_pwd_dir_length 0

set -l fish_config_dir "$HOME/.config/fish"

if test -f "$fish_config_dir/private.fish"
    source "$fish_config_dir/private.fish"
else
    echo "# Private variables not to be commited to source control" > "$fish_config_dir/private.fish"
end

# System specific configs
if type -q uname 
    set -l system_name (uname -s)

    if test $system_name = "Linux"
        source "$fish_config_dir/system/linux/config.fish"
    else if test $system_name = "Darwin"
        source "$fish_config_dir/system/mac/config.fish"
    end
end

alias la "ls -a"
alias sl ls
alias suod sudo

alias esy-shell 'VIRTUAL_ENV="esy[$(basename $(pwd))]" esy shell'
alias esh esy-shell

# ▼ Git Aliases
alias ga  'git add'
alias gl  'git log'
alias gs  'git status'
alias gd  'git diff'
alias gb  'git branch'
alias gbs 'git switch' # Git Branch Switch
alias gc  'git commit'
alias gp  'git push'
# ▲ Git Aliases

alias tms 'tmux-sessionizer'
bind '\cf' 'tmux-sessionizer'

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
