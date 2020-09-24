module CUDNN_CUDA110_jll

if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@optlevel"))
    @eval Base.Experimental.@optlevel 0
end

if VERSION < v"1.3.0-rc4"
    # We lie a bit in the registry that JLL packages are usable on Julia 1.0-1.2.
    # This is to allow packages that might want to support Julia 1.0 to get the
    # benefits of a JLL package on 1.3 (requiring them to declare a dependence on
    # this JLL package in their Project.toml) but engage in heroic hacks to do
    # something other than actually use a JLL package on 1.0-1.2.  By allowing
    # this package to be installed (but not loaded) on 1.0-1.2, we enable users
    # to avoid splitting their package versions into pre-1.3 and post-1.3 branches
    # if they are willing to engage in the kinds of hoop-jumping they might need
    # to in order to install binaries in a JLL-compatible way on 1.0-1.2. One
    # example of this hoop-jumping being to express a dependency on this JLL
    # package, then import it within a `VERSION >= v"1.3"` conditional, and use
    # the deprecated `build.jl` mechanism to download the binaries through e.g.
    # `BinaryProvider.jl`.  This should work well for the simplest packages, and
    # require greater and greater heroics for more and more complex packages.
    error("Unable to import CUDNN_CUDA110_jll on Julia versions older than 1.3!")
end

using Pkg, Pkg.BinaryPlatforms, Pkg.Artifacts, Libdl
import Base: UUID

wrapper_available = false
"""
    is_available()

Return whether the artifact is available for the current platform.
"""
is_available() = wrapper_available

# We put these inter-JLL-package API values here so that they are always defined, even if there
# is no underlying wrapper held within this JLL package.
const PATH_list = String[]
const LIBPATH_list = String[]

# We determine, here, at compile-time, whether our JLL package has been dev'ed and overridden
override_dir = joinpath(dirname(@__DIR__), "override")
if isdir(override_dir)
    function find_artifact_dir()
        return override_dir
    end
else
    function find_artifact_dir()
        return artifact"CUDNN_CUDA110"
    end

    """
        dev_jll()

    Check this package out to the dev package directory (usually ~/.julia/dev),
    copying the artifact over to a local `override` directory, allowing package
    developers to experiment with a locally-built binary.
    """
    function dev_jll()
        # First, `dev` out the package, but don't effect the current project
        mktempdir() do temp_env
            Pkg.activate(temp_env) do
                Pkg.develop("CUDNN_CUDA110_jll")
            end
        end
        # Create the override directory
        override_dir = joinpath(Pkg.devdir(), "CUDNN_CUDA110_jll", "override")
        # Copy the current artifact contents into that directory
        if !isdir(override_dir)
            cp(artifact"CUDNN_CUDA110", override_dir)
        end
        # Force recompilation of that package, just in case it wasn't dev'ed before
        touch(joinpath(Pkg.devdir(), "CUDNN_CUDA110_jll", "src", "CUDNN_CUDA110_jll.jl"))
        @info("CUDNN_CUDA110_ll dev'ed out to /depot/dev/CUDNN_CUDA110_jll with pre-populated override directory")
    end
end
# Load Artifacts.toml file
artifacts_toml = joinpath(@__DIR__, "..", "Artifacts.toml")

# Extract all platforms
artifacts = Pkg.Artifacts.load_artifacts_toml(artifacts_toml; pkg_uuid=UUID("5fa5d4a9-0408-52e0-9638-7667eddd2fce"))
platforms = [Pkg.Artifacts.unpack_platform(e, "CUDNN_CUDA110", artifacts_toml) for e in artifacts["CUDNN_CUDA110"]]

# Filter platforms based on what wrappers we've generated on-disk
filter!(p -> isfile(joinpath(@__DIR__, "wrappers", replace(triplet(p), "arm-" => "armv7l-") * ".jl")), platforms)

# From the available options, choose the best platform
best_platform = select_platform(Dict(p => triplet(p) for p in platforms))

# Silently fail if there's no binaries for this platform
if best_platform === nothing
    @debug("Unable to load CUDNN_CUDA110; unsupported platform $(triplet(platform_key_abi()))")
else
    # Load the appropriate wrapper.  Note that on older Julia versions, we still
    # say "arm-linux-gnueabihf" instead of the more correct "armv7l-linux-gnueabihf",
    # so we manually correct for that here:
    best_platform = replace(best_platform, "arm-" => "armv7l-")
    include(joinpath(@__DIR__, "wrappers", "$(best_platform).jl"))
end

end  # module CUDNN_CUDA110_jll
