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
        # cargo clean
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


build() { 
    # conda activate python-llm-virtual-env
    export PYO3_PYTHON=$(which python)
    # export LD_LIBRARY_PATH=/home/unixuser/miniconda3/envs/python-llm-virtual-env/lib/:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=~/anaconda3/lib/:/usr/lib/wsl/lib:$LD_LIBRARY_PATH
    ./script.sh build_models
    
    dx build --release
}
