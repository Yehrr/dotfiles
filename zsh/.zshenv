# ============================================================================ #
#                                     PATH                                     #
# ============================================================================ #
# Add bin and local bin to path
for dir in "$HOME/bin" "$HOME/.local/bin"; do
	[ -d "$dir" ] && PATH="$dir:$PATH"
done

# ============================================================================ #
#                                    ONEAPI                                    #
# ============================================================================ #
export DPCPP_HOME=~/sycl_workspace
export PATH=$DPCPP_HOME/llvm/build/bin:$PATH
export LD_LIBRARY_PATH=$DPCPP_HOME/llvm/build/lib:$LD_LIBRARY_PATH
