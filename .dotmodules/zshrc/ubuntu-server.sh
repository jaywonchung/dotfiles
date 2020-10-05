# Machine-specific Ubuntu server with CUDA
# NVCC
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# Assigned GPU
export CUDA_DEVICE_ORDER=PCI_BUS_ID
export CUDA_VISIBLE_DEVICES=5

# Crane
export PATH="$HOME/workspace/crane/bin:$PATH"
