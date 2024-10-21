run() { 
    huggingface-cli login --token ""
        
    # cargo run -r -- --server master
    # cargo build --release
    # ./target/release/moonweb --server master
    cargo +nightly build --package server
    cargo +nightly build --package client

    ln -s Cargo.lock ./client/Cargo.lock # doesn't seem to fix the Manganis error "Manganis: Failed to find this package in the lock file"
    (cd client && dx build)

    cargo run -r --bin master -- --server master
    (cd client && dx serve --release)
}

env() { 
    export PYO3_PYTHON=$(which python)
    export LD_LIBRARY_PATH=~/anaconda3/lib/:/usr/lib/wsl/lib:$LD_LIBRARY_PATH
}