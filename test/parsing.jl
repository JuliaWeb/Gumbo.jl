# basic test that parsing works correctly

testdir = dirname(@__FILE__)

const empty_document = HTMLDocument("",HTMLElement{:HTML}([HTMLElement(:head),
                                                           HTMLElement(:body)],
                                                          Dict{String,String}()))

@test parsehtml("") == empty_document
@test_throws GumboParser.InvalidHTMLException parsehtml("", strict=true)


let
    page = open("$testdir/example.html") do example
        example |> readall |> parsehtml
    end
    @test page.doctype == "html"
    root = page.root
    @test tag(root[1][1]) == :meta
    @test root[2][1][1].text == "A simple test page."
end
