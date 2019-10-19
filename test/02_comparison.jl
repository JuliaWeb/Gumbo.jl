# test for comparisons and hashing

@testset "Comparisons: HTMLText" begin
    x = HTMLText("test")
    y = HTMLText("test")
    x1 = HTMLText("test1")
    @test x == y
    @test hash(x) == hash(y)
    @test x1 != y
    @test hash(x1) != hash(y)
end
@testset "Comparisons: HTMLElement" begin
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
@testset "Comparisons: HTMLDocument" begin
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
