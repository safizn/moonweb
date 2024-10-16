setup() { 
    # global dependencies
        # - cuda framework
        # - nvcc gpu driver
        # - python 3 
        # - dioxus https://dioxuslabs.com/learn/0.4/CLI/installation/
        cargo install dioxus-cli 
    
    # Cuda installation for WSL2
    {
        pushd tmp
        wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
        sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.6.2/local_installers/cuda-repo-wsl-ubuntu-12-6-local_12.6.2-1_amd64.deb
        sudo dpkg -i cuda-repo-wsl-ubuntu-12-6-local_12.6.2-1_amd64.deb
        sudo cp /var/cuda-repo-wsl-ubuntu-12-6-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda-toolkit-12-6
        pushd 

        # test cuda ?
        sudo docker run --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark
    }

    # anaconda package/environment manager 
    {
        mkdir -p ./tmp/
        pushd tmp
        apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
        curl -O https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
        chmod +x ./Anaconda3-2024.02-1-Linux-x86_64.sh
        ./Anaconda3-2024.02-1-Linux-x86_64.sh
        conda config --set auto_activate_base True
        popd
    }

    conda create -n python-llm-virtual-env python=3.9 anaconda

    {
        conda install torch==2.4.1 pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
        conda cudatoolkit -c pytorch

        conda install xformers -c xformers
        # pip install xformers --force-reinstall --no-deps 
        # !pip install xformers==0.0.29.dev923


        # Other installation (some redundant)
        {    
            conda install diffusers transformers sentencepiece
            pip install git+https://github.com/huggingface/diffusers.git # Fix for error with importing `diffusers` package
            conda install -c nvidia cuda-python
            
            {
                # FLASH_ATTENTION_SKIP_CUDA_BUILD=TRUE pip install flash-attn --no-build-isolation
                # pip install flash-attn 
                pushd tmp
                git clone https://github.com/Dao-AILab/flash-attention.git
                cd flash-attention
                export FLASH_ATTENTION_SKIP_CUDA_BUILD=TRUE
                python setup.py install
                popd
            }

        }    
        
    }

}

