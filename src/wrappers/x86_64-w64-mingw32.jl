# Autogenerated wrapper script for CUDNN_CUDA110_jll for x86_64-w64-mingw32
export libcudnn

using CUDA_jll
JLLWrappers.@generate_wrapper_header("CUDNN_CUDA110")
JLLWrappers.@declare_library_product(libcudnn, "cudnn64_8.dll")
function __init__()
    JLLWrappers.@generate_init_header(CUDA_jll)
    JLLWrappers.@init_library_product(
        libcudnn,
        "bin\\cudnn64_8.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
