set -gx QT_QPA_PLATFORMTHEME "qt6ct"
set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/lib/:usr/local/lib"
set -gx STUDIO_JDK "/usr/lib/jvm/java-20-temurin/"

set -gx ANDROID_HOME "$HOME/Android/Sdk"
fish_add_path -P "$ANDROID_HOME/emulator"
fish_add_path -P "$ANDROID_HOME/platform-tools"

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path -P /opt/resolve/bin/
fish_add_path -P /var/lib/flatpak/exports/bin
fish_add_path -P $HOME/.dotnet/tools
fish_add_path -P $HOME/Utilities
fish_add_path -P "$HOME/Tools"
fish_add_path -P "$HOME/.dotnet"

alias ls exa
alias lsg "exa --group-directories-first"
#alias aws awsv2
alias copy "xclip -in -sel c"
alias paste "xclip -out -sel c"
