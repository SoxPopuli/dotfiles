
#!/bin/env bash

for dir in $(find . -maxdepth 1 -type d -not -path '.' -not -path './.git')
do
    cd "${dir}"
    echo "Pulling ${dir}..."
    git pull
    cd ..
done
