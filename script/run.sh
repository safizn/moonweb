run() { 
    export PYO3_PYTHON=$(which python)
    export LD_LIBRARY_PATH=/home/unixuser/anaconda3/lib/:/usr/lib/wsl/lib:$LD_LIBRARY_PATH
    
    cargo run -r -- --server master
    dx serve --release
}
