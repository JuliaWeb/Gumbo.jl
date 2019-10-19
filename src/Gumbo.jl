"""
    Gumbo
Gumbo is a Julia wrapper around Google's Gumbo library for parsing HTML.
"""
module Gumbo
    if isfile(joinpath(dirname(@__DIR__), "deps", "deps.jl"))
        include(joinpath("..", "deps", "deps.jl"))
    else
        throw(error("Gumbo not properly installed. Please run Pkg.build(\"Gumbo\")"))
    end
    using Libdl: dlopen, dlsym
    import Base: (==), isequal, hash, getindex, setindex!, print, show, push!
    import AbstractTrees: children
    foreach(include,
            filter(filename -> occursin(r"^\d+_.*\.jl$", filename),
                   readdir(@__DIR__)) |>
            sort!)
    export HTMLElement,
           HTMLDocument,
           HTMLText,
           NullNode,
           HTMLNode,
           attrs,
           text,
           tag,
           children,
           getattr,
           setattr!,
           parsehtml,
           postorder,
           preorder,
           breadthfirst,
           prettyprint
end
