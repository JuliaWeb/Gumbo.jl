# tests of basic utilities for working with HTML

import Gumbo: HTMLNode, NullNode

# convenience constructor works
@test HTMLElement(:body) == HTMLElement{:body}(HTMLNode[],
                                               NullNode(),
                                               1,
                                               Dict{AbstractString,AbstractString}())

# accessing tags works
@test HTMLElement(:body) |> tag == :body

let
    elem = HTMLElement{:body}(HTMLNode[], NullNode(), 1, Dict("foo" => "bar"))
    @test getattr(elem, "foo") == "bar"
    @test getattr(elem, "foo", "baz") == "bar"
    @test getattr(elem, "bar", "qux") == "qux"
    @test getattr(() -> "qux", elem, "bar") == "qux"
end
