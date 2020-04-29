module Gumbo
using Gumbo_jll, Libdl

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
       hasattr,
       getattr,
       setattr!,
       parsehtml,
       postorder,
       preorder,
       breadthfirst,
       prettyprint

include("htmltypes.jl")
include("manipulation.jl")
include("comparison.jl")
include("io.jl")
include("conversion.jl")

end
