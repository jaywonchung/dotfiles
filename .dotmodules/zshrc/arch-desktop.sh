# Machine-specific Arch Linux desktop
# Kitty
if [ "$TERM" = "xterm-kitty" ]; then
  alias icat='kitty +kitten icat'
fi

# NVCC
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# llvm and clang (for ccls)
export PATH="/usr/local/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin:$PATH"

# rust cargo
export PATH="$HOME/.cargo/bin:$PATH"
