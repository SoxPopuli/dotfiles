# env.nu
#
# Installed by:
# version = "0.103.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
def command-exists [command: string] { not (which $command | is-empty) }

if (command-exists carapace) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
    mkdir $"($nu.cache-dir)"
    carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
}

use std/util "path add"

if (command-exists fnm) {
    let vars: list = fnm env --shell bash
        | lines 
        | parse 'export {key}={value}' 
        | upsert 'value' { |x| $x.value | str replace ':"$PATH"' '' }
        | upsert 'value' { str replace --all '"' '' }

    let vars: record = $vars | transpose -rd

    let path = $vars | get -o "PATH"
    let vars = $vars | reject "PATH"

    if ($path != null) {
        path add $path
    }

    load-env $vars
}

let home_manager_session_script = $"($env.HOME)/.nix-profile/etc/profile.d/hm-session-vars.sh"

if ($home_manager_session_script | path exists) {
    open $home_manager_session_script
    | lines
    | parse 'export {key}={value}'
    | update 'value' { str replace --all '"' '' }
    | transpose -rd
    | load-env
}

use functions.nu *

if (command-exists "opam") {
    load-env (opam-env)
}
