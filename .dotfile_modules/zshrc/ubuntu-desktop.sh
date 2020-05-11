# Machine-specific Ubuntu 18.04 desktop
# Minimize application when clicking on dock icon
export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/

# NVCC
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# OpenMPI
export PATH="$HOME/.openmpi/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.openmpi/lib:$LD_LIBRARY_PATH"

# Ncurses6 (for QEMU in OS-PA)
export LD_LIBRARY_PATH="/usr/local/ncurses/lib:$LD_LIBRARY_PATH"

# riscv64-linux-gnu-gdb (for OS-PA)
export PATH="$HOME/builds/gdb-8.3.1-riscv64-linux-gnu/bin:$PATH"

# llvm and clang (for ccls)
export PATH="/usr/local/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin:$PATH"

# rust cargo
export PATH="$HOME/.cargo/bin:$PATH"
