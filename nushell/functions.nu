# List docker images
export def di [] {
    docker images --format json 
    | from json -o
    | reject Containers Digest SharedSize UniqueSize VirtualSize CreatedSince 
    | update CreatedAt { str substring ..-4 | into datetime } 
    | update Size { into filesize }
    | move Tag --first 
    | move ID --after Tag 
    | move Repository --before Tag
    | rename -b { str downcase }
    | rename -c { createdat: created }
}

def hide-empty []: list<any> -> any {
    if ($in | is-empty) {
        null
    } else {
        $in
    }
}

# List docker processes
export def dp [] {
    docker ps --format json --no-trunc 
    | from json -o 
    | reject Networks Command LocalVolumes Labels RunningFor Status 
    | update Mounts { str replace $env.HOME '~' | split row ',' | compact -e | hide-empty }
    | update ID { str substring 0..11 } 
    | update Ports { split row ',' | str trim | compact -e | hide-empty }
    | update Size { into filesize } 
    | update CreatedAt { str substring ..-4 | into datetime } 
    | move CreatedAt --last 
    | move ID --after Image 
    | move Ports --last
    | move Mounts --last
    | move Names --first
    | rename -b { str downcase }
    | rename -c { createdat: created }
}

export def --wrapped df [...rest] {
    let t: table = with-env { "BLOCKSIZE": 1024 } { ^df ...$rest }
        | str replace 'Mounted on' 'mounted_on'
        | from ssv --minimum-spaces 1
        | rename -b { str downcase }

    let cols = ($t | columns)

    let t: table = if '1k-blocks' in $cols { 
        $t | rename -c { '1k-blocks': size }
    } else {
        $t | rename -c { '1024-blocks': size }
    }

    $t
    | update size { $"($in) KiB" | into filesize }
    | update used { $"($in) KiB" | into filesize }
    | update available { $"($in) KiB" | into filesize }
    | update 'use%' { str trim --char '%' | into int }
}

def append-if [condition: bool, element: any]: list -> list {
    if $condition {
        $in | append $element
    } else {
        $in
    }
}

# Run gamescope with pre-existing settings
export def --wrapped gamescope-start [
    cmd?: string
    --backend (-b): string
    --sensitivity (-s): int
    --output-width (-W): int # Output width
    --output-height (-H): int # Output height
    --nested-width (-w): int # Game width
    --nested-height (-h): int # Game height
    --steam (-e)
    --mangoapp (-m)
    --no-grab-cursor
    ...rest
] {
    let backend = $backend | default "sdl"
    let sensitivity = $sensitivity | default 2

    mut args = [
        --backend $backend 
        -w ($nested_width | default 3840) 
        -h ($nested_height | default 2160)
        -W ($output_width | default 3840)
        -H ($output_height | default 2160)
        -s $sensitivity 
    ]

    $args = $args | append-if $mangoapp "--mangoapp"
    $args = $args | append-if (not $no_grab_cursor) "--force-grab-cursor"
    $args = $args | append-if $steam "--steam"

    if ($cmd | is-not-empty) {
        gamescope ...$args $cmd -- ...$rest
    } else {
        gamescope ...$args -- ...$rest
    }
}

export def --wrapped with-gamescope [process_closure: closure, ...args] {
    let jid = job spawn { gamescope-start ...$args }

    with-env { DISPLAY: ":1" } $process_closure

    job kill $jid
}

export def extract [archive: string] {
    let file_name = $archive | split row '.' | drop 1 | str join '.'
    7z x $archive -o($file_name)
}

# Convert table with two columns to a record
export def "table to-record" [
    key?: string # Name of first column
    value?: string # Name of second column
]: table -> record {
    let key = $key | default "column0"
    let value = $value | default "column1"

    $in | reduce -f {} {|it, acc| $acc | upsert ($it | get $key) ($it | get $value) }
}

# Read a .env file and return a record
export def read-env []: string -> record {
    $in 
    | lines
    | where { is-not-empty }
    | str trim
    | where { not ($in | str starts-with '#') }
    | str replace -r '^export ' ''
    | split column -n 2 -r '\s*=\s*' key value
    | upsert value { default "" | str trim -c '"' }
    | each { |row|
        if ($row.value | str starts-with '$') {
            update value { ^bash -c $'printf "%q" "($row.value)"'
        }
        } else { $row }
    }
    | transpose -r -d -l
}

# eXamine (open file or ls directory)
export def x [
    file?: string
    -a # show hidden (if directory)
] {
    let file = match $in {
        null => ($file | default "."),
        _ => $in
    }

    match ($file | path type) {
        "file" | "symlink" => (open $file),
        "dir" => (if $a {
            (ls -a $file)
        } else {
            (ls $file)
        }),
        null => null,
    }
}

export def git-log [
    branch?: string
    --no-trunc (-t) # Don't truncate subject line
    --max-subject-len (-l): int
] {
    let max_subject_len = $max_subject_len | default 60

    git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD 
    | lines 
    | do -i { split column "»¦«" commit subject name email date } 
    | upsert date {|d| $d.date | into datetime} 
    | upsert subject { 
        if not $no_trunc and (($in |  str length) > $max_subject_len) { 
            ($in | str substring ..=$max_subject_len | str trim --right) + "..." 
        } else { 
            $in 
        }  
    }
}

export def "git branches" [
    --all (-a) # Show local and remote branches
] {
    let cmd = if $all {
        git branch -v --all
    } else {
        git branch -v
    }

    $cmd
    | parse --regex '([\w\d_\-\/\.]+)\s+([a-z0-9]+) (\[gone\])?\s?(.*)' 
    | rename branch ref gone message
    | upsert gone { 
        match $in {
            null => false
            _ => true
        }
    }
}

export def --wrapped cargo-test-file [...args] {
    cargo test --no-run ...$args
    | complete
    | get stderr
    | lines 
    | last 
    | parse -r '\((.*)\)' 
    | get capture0.0
}

export def cloc [] {
    let files = git ls-files | lines
    let loc = ^cloc --json ...$files | from json

    $loc
    | transpose language info
    | upsert file_count { |x| $x.info | get -o nFiles }
    | upsert blank { |x| $x.info | get -o blank }
    | upsert comment { |x| $x.info | get -o comment }
    | upsert code { |x| $x.info | get -o code }
    | reject info
    | skip 1
}

export def --wrapped opam-env [...args] {
    opam env ...$args
    | lines 
    | each { str replace -r ';.*$' '' } 
    | split column -n 2 '=' key value 
    | upsert value { str trim -c "'" } 
    | transpose -rd
}

# Kill all members of `process`
export def killall [
    process: string, # process name
] {
    let kill_fn = { |process|
        let pid = $process | get pid
        
        kill -f $pid

        $process
    }

    ps 
    | where {|x| $x.name | str contains -i $process }
    | each $kill_fn
}
