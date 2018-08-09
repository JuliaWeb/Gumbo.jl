# basic test that parsing works correctly

testdir = dirname(@__FILE__)

@test_throws Gumbo.InvalidHTMLException parsehtml("", strict=true)

let
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

let
    page = parsehtml("<weird></weird")
    @test tag(page.root[2][1]) == :weird
end


# test that non-standard tags, with attributes, are parsed correctly

let
    page = Gumbo.parsehtml("<my-element cool></my-element>")
    @test tag(page.root[2][1]) == Symbol("my-element")
    @test Gumbo.attrs(page.root[2][1]) == Dict("cool" => "")
end
