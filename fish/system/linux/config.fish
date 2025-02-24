set -gx FZF_DEFAULT_OPTS "--history=$HOME/.fzf_history --tmux"

set -gx GTK_THEME Adwaita:dark
set -gx GTK2_RC_FILES /usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc

# set -gx QT_STYLE_OVERRIDE Adwaita-Dark
set -gx QT_QPA_PLATFORMTHEME qt6ct

fish_add_path "$HOME/.local/share/nvim/mason/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path -P /opt/resolve/bin/
fish_add_path -P /var/lib/flatpak/exports/bin
fish_add_path -P $HOME/.dotnet/tools
fish_add_path -P "$HOME/Utilities"
fish_add_path -P "$HOME/Tools"
fish_add_path -P "$HOME/.dotnet"
fish_add_path -P "$HOME/.dotnet/tools"
fish_add_path -P "$HOME/.local/share/bob/nvim-bin" #neovim version manager
fish_add_path -P "$HOME/.ghcup/bin"

alias ls exa
alias lsg "exa --group-directories-first"
#alias aws awsv2
alias copy "xclip -in -sel c"
alias paste "xclip -out -sel c"
