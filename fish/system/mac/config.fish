set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf_history --tmux"

fish_add_path /usr/local/opt/rustup/bin
fish_add_path "$HOME/.dotnet/tools"
fish_add_path "/usr/local/opt/python/libexec/bin"
fish_add_path "$HOME/bin"
fish_add_path "/usr/local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/Tools"

set -gx GPG_TTY (tty)
