# tests of basic utilities for working with HTML

import GumboParser: HTMLNode, NullNode

# convenience constructor works
@test HTMLElement(:body) == HTMLElement{:body}(HTMLNode[],
                                               NullNode(),
                                               Dict{String,String}())

# accessing tags works
@test HTMLElement(:body) |> tag == :body
