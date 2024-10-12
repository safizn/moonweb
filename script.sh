#!/bin/bash

# ./script.sh build_models
build_models() { 
    # Function to recursively list folders containing "Cargo.toml"
    find_cargo_folders() {
        local dir="$1"

        # Check if the current directory contains "Cargo.toml"
        if [[ -f "$dir/Cargo.toml" ]]; then
            echo "$dir"
        fi

        # Recursively search subdirectories
        for subdir in "$dir"/*; do
            if [[ -d "$subdir" ]]; then
            find_cargo_folders "$subdir"
            fi
        done
    }

    # Function to execute "cargo build --release" in each folder
    build_in_folders() {
    for folder in "$@"; do
        pushd "$folder"
        cargo build --release
        popd
    done
    }
    
    # Start the search from the current directory
    cargo_folder_list=($(find_cargo_folders ./models))

    # Print the list of folders
    echo "Folders containing Cargo.toml:"
    for folder in "${cargo_folder_list[@]}"; do
    echo "$folder"
    done

    build_in_folders "${cargo_folder_list[@]}"
}

setup() { 
    # global dependencies
        # - cuda framework
        # - nvcc gpu driver
        # - python 3 
        # - dioxus https://dioxuslabs.com/learn/0.4/CLI/installation/
        cargo install dioxus-cli 
    
    ./script.sh build_models

    # install miniconda
    # https://docs.anaconda.com/miniconda/
    {
        mkdir -p ~/miniconda3
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
        bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
        rm ~/miniconda3/miniconda.sh
        # restart shell then: 
        source ~/miniconda3/bin/activate
        conda init --all
    }

    conda create -n python-llm-virtual-env python=3.9 anaconda
    conda activate python-llm-virtual-env
    export PYO3_PYTHON=$(which python)
}


run() { 
    cargo run -r -- --server master
    dx build --release
    dx serve --release
}

# call function in this script file from commandline argument
{
    fn_name="$1"
    if [[ $# -lt 1 ]]; then
        # This case can be used for executing $`source ./script.sh` to load functions to current shell session.
        exit 0
    elif ! declare -f "$fn_name" || ! [[ $(type -t "$fn_name") ]]; then # check if defined in current file or sourced declaration 
        echo "Error: function '$fn_name' not declared. "
        exit 1
    else 
        # redirect call to function name provided
        shift
        "$fn_name" "$@"
    fi
}