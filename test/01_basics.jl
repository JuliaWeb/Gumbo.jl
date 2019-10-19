# tests of basic utilities for working with HTML
# convenience constructor works
@test HTMLElement(:body) == HTMLElement{:body}(HTMLNode[],
                                               NullNode(),
                                               Dict{AbstractString,AbstractString}())

# accessing tags works
@test HTMLElement(:body) |> tag == :body

@testset "getattr" begin
    elem = HTMLElement{:body}(HTMLNode[], NullNode(), Dict("foo" => "bar"))
    @test getattr(elem, "foo") == "bar"
    @test getattr(elem, "foo", "baz") == "bar"
    @test getattr(elem, "bar", "qux") == "qux"
    @test getattr(() -> "qux", elem, "bar") == "qux"
end
