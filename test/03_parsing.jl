# basic test that parsing works correctly

testdir = dirname(@__FILE__)

@test_throws InvalidHTMLException parsehtml("", strict = true)

@testset "Parsing: Basic Page" begin
    page = open("$testdir/fixtures/example.html") do example
        read(example, String) |> parsehtml
    end
    @test page.doctype == "html"
    root = page.root
    @test tag(root[1][1]) == :meta
    @test root[2][1][1].text == "A simple test page."
    @test root[2][1][1].parent === root[2][1]
end

# test that nonexistant tags are parsed as their actual name and not "unknown"

@testset "Parsing: Nonexistant tags" begin
    page = parsehtml("<weird></weird")
    @test tag(page.root[2][1]) == :weird
end

# test that non-standard tags, with attributes, are parsed correctly

@testset "Parsing: Non-standard tags" begin
    page = parsehtml("<my-element cool></my-element>")
    @test tag(page.root[2][1]) == Symbol("my-element")
    @test attrs(page.root[2][1]) == Dict("cool" => "")
end
