# basic test that parsing works correctly

testdir = dirname(@__FILE__)

@test_throws Gumbo.InvalidHTMLException parsehtml("", strict=true)

let
    page = open("$testdir/example.html") do example
        example |> readstring |> parsehtml
    end
    @test page.doctype == "html"
    root = page.root
    @test tag(root[1][1]) == :meta
    @test root[2][1][1].text == "A simple test page."
    @test is(root[2][1][1].parent, root[2][1])
end


# test that nonexistant tags are parsed as their actual name and not "unknown"

let
    page = parsehtml("<weird></weird")
    @test tag(page.root[2][1]) == :weird
end
