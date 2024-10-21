run() { 
    huggingface-cli login --token ""
        
    cargo run -r -- --server master
    # cargo build --release
    # ./target/release/moonweb --server master
    
    dx serve --release
}

env() { 
    export PYO3_PYTHON=$(which python)
    export LD_LIBRARY_PATH=~/anaconda3/lib/:/usr/lib/wsl/lib:$LD_LIBRARY_PATH
}