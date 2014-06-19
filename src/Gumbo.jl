module Gumbo

if isfile(joinpath(dirname(dirname(@__FILE__)),"deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("Gumbo not properly installed. Please run Pkg.build(\"Gumbo\")")
end

include("CGumbo.jl")

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
       breadthfirst

include("htmltypes.jl")
include("manipulation.jl")
include("comparison.jl")
include("io.jl")
include("conversion.jl")

end
