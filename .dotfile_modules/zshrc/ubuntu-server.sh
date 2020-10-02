# Machine-specific Ubuntu server with CUDA
# Neovim
if ! command -v nvim &> /dev/null; then
    mkdir -p ~/.local/bin
    ln -s $(which vim) ~/.local/bin/nvim
fi

# NVCC
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# Assigned GPU
export CUDA_DEVICE_ORDER=PCI_BUS_ID
export CUDA_VISIBLE_DEVICES=5

# Crane
export PATH="$HOME/workspace/crane/bin:$PATH"
