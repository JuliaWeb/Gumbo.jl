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
    @test typeof(root.children[1].children[1]).parameters[1] == :meta
    @test root.children[2].children[1].children[1].text == "A simple test page."
end
