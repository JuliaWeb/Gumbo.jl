
# test for comparisons and hashing

let
    x = HTMLText("test")
    y = HTMLText("test")
    @test x == y
    @test hash(x) == hash(y)
    x.text *= "1"
    @test x != y
    @test hash(x) != hash(y)
    y.text *= "1"
    @test x == y
    @test hash(x) == hash(y)
end

let
    x = HTMLElement(:div)
    y = HTMLElement(:div)
    @test x == y
    @test hash(x) == hash(y)
    push!(x, HTMLElement(:p))
    @test x != y
    @test hash(x) != hash(y)
    push!(y, HTMLElement(:p))
    @test x == y
    @test hash(x) == hash(y)
    setattr!(x,"class","test")
    @test x != y
    @test hash(x) != hash(y)
    setattr!(y,"class","test")
    @test x == y
    @test hash(x) == hash(y)
end

let
    x = HTMLDocument("html", HTMLElement(:html))
    y = HTMLDocument("html", HTMLElement(:html))
    @test x == y
    @test hash(x) == hash(y)
    x.doctype = ""
    @test x != y
    @test hash(x) != hash(y)
    y.doctype = ""
    @test x == y
    @test hash(x) == hash(y)
end
