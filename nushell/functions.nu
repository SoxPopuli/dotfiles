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
    (^df ...$rest)
    | str replace 'Mounted on' 'mounted_on'
    | from ssv --minimum-spaces 1
    | rename -b { str downcase }
    | rename -c { '1k-blocks': size }
    | update size { $"($in) KiB" | into filesize }
    | update used { $"($in) KiB" | into filesize }
    | update available { $"($in) KiB" | into filesize }
    | update 'use%' { str trim --char '%' | into int }
}

# Run gamescope with pre-existing settings
export def gamescope-start [cmd: string] {
    gamescope --backend sdl -w 3840 -h 2160 -W 3840 -H 2160 -s 2 --force-grab-cursor $cmd
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
    | filter { is-not-empty }
    | filter { not ($in | str trim | str starts-with '#') }
    | str trim
    | str replace -r '^export ' ''
    | split column -n 2 -r '\s*=\s*'
    | rename key value
    | upsert value { default "" | str trim -c '"' }
    | each { |row|
        if ($row.value | str starts-with '$') {
            update value { ^bash -c $"echo ($row.value)" }
        } else { $row }
    }
    | table to-record key value
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
