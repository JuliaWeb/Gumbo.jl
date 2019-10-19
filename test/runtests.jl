using Test, Gumbo, AbstractTrees
using Gumbo: HTMLNode, NullNode, InvalidHTMLException

foreach(include,
        filter(filename -> occursin(r"^\d+_.*\.jl$", filename),
               readdir(@__DIR__)) |>
        sort!)
