module GumboParser

include("Gumbo.jl")

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
       parsehtml

include("htmltypes.jl")
include("manipulation.jl")
include("comparison.jl")
include("io.jl")
include("conversion.jl")

end
