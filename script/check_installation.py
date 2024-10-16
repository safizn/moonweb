import torch

print(torch.__version__)
my_tensor = torch.tensor([[1, 2, 3], [4, 5, 6]], dtype=torch.float32, device="cpu")
print(my_tensor)
print(torch.cuda.is_available())


import torch
x = torch.rand(5, 3)
print(x)

import torch
def supports_flash_attention(device_id):
    """Check if a GPU supports FlashAttention."""
    major, minor = torch.cuda.get_device_capability(device_id)
    
    # Check if the GPU architecture is Ampere (SM 8.x) or newer (SM 9.0)
    is_sm8x = major == 8 and minor >= 0
    is_sm90 = major == 9 and minor == 0

    return is_sm8x or is_sm90

print(supports_flash_attention(0))
# alternative to "flash attention" is 'conda install xformers -c xformers'

# nvidia-smi --query-gpu=name,compute_cap,driver_version --format=csv

# test 'xformers' installation
# $ python -m xformers.info