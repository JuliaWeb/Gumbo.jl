
let
    # roundtrip test
    # TODO this could be done with Quickcheck if we had a way of
    # generating "interesting" HTML documents
    doc = open("$testdir/fixtures/example.html") do example
        read(example, String) |> parsehtml
    end
    io = IOBuffer()
    print(io, doc)
    seek(io, 0)
    newdoc = read(io, String) |> parsehtml
    @test newdoc == doc
end

tests = [
    "30",  # regression test for issue #30
    "multitext",  # regression test for multiple HTMLText in one HTMLElement
    "varied",  # relatively complex example
]
for test in tests
    let
        doc = open("$testdir/fixtures/$(test)_input.html") do example
            read(example, String) |> parsehtml
        end
        io = IOBuffer()
        print(io, doc.root, pretty=true)
        seek(io, 0)
        @test read(io, String) ==
            read(open("$testdir/fixtures/$(test)_output.html"), String)
    end
end
