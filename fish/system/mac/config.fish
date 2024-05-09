# load fenv
set fish_function_path $fish_function_path $HOME/Documents/plugin-foreign-env/functions

# load nix-darwin
fenv source /etc/static/bashrc 

# load direnv
direnv hook fish | source

fish_add_path "$HOME/.dotnet/tools"
fish_add_path "/usr/local/opt/python/libexec/bin"
fish_add_path "$HOME/bin"
fish_add_path "/usr/local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/Tools"

set -gx GPG_TTY (tty)
