# Machine-specific Ubuntu server with CUDA
# NVCC
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# Crane
export PATH="$HOME/workspace/crane/bin:$PATH"

# Kubectl
export PATH="$HOME/.local/bin:$PATH"
