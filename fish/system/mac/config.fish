set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf_history --tmux"

fish_add_path "$HOME/.local/share/nvim/mason/bin"
fish_add_path /usr/local/opt/rustup/bin
fish_add_path "$HOME/.dotnet/tools"
fish_add_path "/usr/local/opt/python/libexec/bin"
fish_add_path "$HOME/bin"
fish_add_path "/usr/local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/Tools"
fish_add_path "/opt/homebrew/bin"

set -gx GPG_TTY (tty)

alias git-config-personal \
    "git config --local user.email charliesmith5019@gmail.com \
     && git config --local user.name 'Charlotte Smith'"
