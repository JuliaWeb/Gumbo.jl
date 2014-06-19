module Gumbo

include("../deps/deps.jl")

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
