def command-exists [command: string] { not (which $command | is-empty) }

def gen-runtime-config [] {
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

    save-command "use std/util \"path add\""

    save-path "/opt/homebrew/bin"
    save-path "/opt/homebrew/Caskroom"

    let is_macos = (sys host).name == "Darwin"

    if ($is_macos) {
        save-alias copy "pbcopy"
        save-alias paste "pbpaste"
    } else if (command-exists "xclip") {
        save-alias copy "xclip -in -sel c"
        save-alias paste "xclip -out -sel c"
    } else {
        save-alias copy "wl-copy"
        save-alias paste "wl-paste"
    }

    if (command-exists bat) {
        save-alias cat "bat"
    }

    if (command-exists "fnm") {
        let vars = fnm env --shell bash
            | lines 
            | parse 'export {key}={value}' 
            | upsert 'value' { |x| $x.value | str replace ':"$PATH"' '' }

        for $it in $vars {
            if ($it.key == "PATH") {
                save-command $"path add ($it.value)"
            } else {
                save-command $"$env.($it.key) = ($it.value)"
            }
        }
    }

    if (command-exists zoxide) {
        zoxide init nushell | save -f $"($nu.default-config-dir)/zoxide.nu"
        save-command "source zoxide.nu"
    }
}
