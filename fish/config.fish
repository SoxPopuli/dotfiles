fish_vi_key_bindings

set -gx EDITOR nvim
set -gx AWS_SDK_LOAD_CONFIG 1 # Use ~/.aws/config to resolve aws credentials
set -gx fish_prompt_pwd_dir_length 0

set -gx __fish_git_prompt_char_upstream_ahead " ↑"
set -gx __fish_git_prompt_char_upstream_behind " ↓"
set -gx __fish_git_prompt_color_upstream yellow
set -gx __fish_git_prompt_showupstream informative

if test -z "$fish_config_dir"
    set -g fish_config_dir "$HOME/.config/fish"
end

if test -f "$fish_config_dir/private.fish"
    source "$fish_config_dir/private.fish"
else
    echo "# Private variables not to be commited to source control" > "$fish_config_dir/private.fish"
end

#start ssh-agent
eval (ssh-agent -c) > /dev/null

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
abbr sl ls
abbr suod sudo

alias esy-shell 'VIRTUAL_ENV="esy($(basename $(pwd)))" esy shell'
abbr esh esy-shell

# ▼ Git Aliases
abbr g   'git'
abbr ga  'git add'
abbr gl  'git log'
abbr gt  'git status'
abbr gd  'git diff'
abbr gb  'git branch'
abbr gs  'git switch'
abbr gc  'git commit'
abbr gp  'git push'
abbr gfo 'git fetch origin'
abbr gaa 'git add -Av'
abbr gpl 'git pull'
# ▲ Git Aliases

alias tmux-sessionizer "$HOME/.config/tmux-sessionizer"

abbr tms 'tmux-sessionizer'
bind '\cf' 'tmux-sessionizer'

abbr nv 'nvim'
abbr vi 'nvim'
alias vim 'nvim'

# Node version manager (Fast Node Manager)
if type -q fnm
    fnm env | source
end

abbr ndc 'nix develop -c'

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

alias git-delete-old-branches \
    "git fetch origin --prune && git branch -v | grep '\[gone\]' | awk '{ print \$1 }' | xargs git branch -D"

direnv hook fish | source
fzf --fish | source
zoxide init fish | source
