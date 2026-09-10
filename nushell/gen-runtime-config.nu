#!/usr/bin/env nu

export def command-exists [command: string] { not (which $command | is-empty) }

export def main [] {
    let file = $"($nu.default-config-dir)/runtime-config.nu"

    def save-command [cmd: string] {
        $"($cmd)\n" | save -a $file
    }

    def save-alias [alias: string, cmd: string] {
        $"alias ($alias) = ($cmd)\n" | save -a $file
    }

    def save-path [dir: string] {
        if ($dir | path exists) {
            save-command $"path add ($dir)"
        }
    }

    '' | save -f $file

    save-command "use functions.nu *"
    save-command "use std/util \"path add\""

    save-path "/opt/homebrew/bin"
    save-path "/opt/homebrew/Caskroom"

    save-path "/home/linuxbrew/.linuxbrew/bin"
    save-path "/home/linuxbrew/.linuxbrew/opt/node@24/bin"

    if (command-exists bat) {
        save-alias cat "bat"
    } else if (command-exists batcat) {
        save-alias cat "batcat"
        save-alias bat "batcat"
    }

    if (command-exists zoxide) {
        let zoxide_path = $"($nu.default-config-dir)/private/zoxide.nu"

        zoxide init nushell | save -f $zoxide_path
        save-command $"source ($zoxide_path)"
    }

    if (command-exists jj) {
      let jj_completion_path = $"($nu.default-config-dir)/private/jj.nu"

      jj util completion nushell | save -f $jj_completion_path
      save-command $"source ($jj_completion_path)"
    }
}
