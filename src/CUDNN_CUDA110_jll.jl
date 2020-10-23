# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule CUDNN_CUDA110_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("CUDNN_CUDA110")
JLLWrappers.@generate_main_file("CUDNN_CUDA110", UUID("5fa5d4a9-0408-52e0-9638-7667eddd2fce"))
end  # module CUDNN_CUDA110_jll
