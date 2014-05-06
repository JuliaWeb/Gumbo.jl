# tests of basic utilities for working with HTML

import GumboParser: HTMLNode

# convenience constructor works
@test HTMLElement(:body) == HTMLElement{:body}(HTMLNode[],Dict{String,String}())

# accessing tags works
@test HTMLElement(:body) |> tag == :body
