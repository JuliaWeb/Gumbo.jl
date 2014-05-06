module GumboParser

import Gumbo

# TODO export HTMLNode?
export HTMLElement,
       HTMLDocument,
       HTMLText,
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
