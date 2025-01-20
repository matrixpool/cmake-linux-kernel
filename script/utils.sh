#!/bin/bash

#get compiler release default rootfs path
get_base_root_dir(){
    local CROSS_COMPILER="$1"

    #cut program paths
    compiler_paths=$(type ${CROSS_COMPILER})
    compiler_paths=$(echo "$compiler_paths" | awk -F 'is ' '{print $2}')

    #find compiler root path
    compiler_paths="/"$(echo ${compiler_paths#*/})
    compiler_paths=$(echo ${compiler_paths%bin*})
    
    echo ${compiler_paths}
}

#delete files exclude some spec files
delete_file_by_exclude(){
    local target_dir="$1"
    local exclude_files=("${@:2}")

    #enable regular expressions
    shopt -s extglob

    find "${target_dir}" -mindepth 1 -maxdepth 1 | while read -r file; do
        filename=$(basename "${file}")

        exclude=false
        for exclude_pattern in "${exclude_files[@]}"; do
            if [[ "$filename" == $exclude_pattern ]]; then
                exclude=true
                break
            fi
        done

        if [ "$exclude" = false ]; then
            rm -rf "$file"
        fi
    done

    #disable regular expressions
    shopt -u extglob
}

