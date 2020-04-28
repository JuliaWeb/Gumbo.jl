
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
    "whitespace",  # whitespace sensitive
]
@testset for test in tests
    let
        doc = open("$testdir/fixtures/$(test)_input.html") do example
            parsehtml(read(example, String), preserve_whitespace = (test == "whitespace"))
        end
        io = IOBuffer()
        print(io, doc.root, pretty = (test != "whitespace"))
        seek(io, 0)
        ground_truth = read(open("$testdir/fixtures/$(test)_output.html"), String)
        # Eliminate possible line ending issues
        ground_truth = replace(ground_truth, "\r\n" => "\n")
        @test read(io, String) == ground_truth
    end
end

@testset "xml entities" begin
    io = IOBuffer()

    orig = """<p class="asd&gt;&amp;-2&quot;">&lt;faketag&gt;</p>"""
    print(io, parsehtml(orig))
    @test occursin(orig, String(take!(io)))
end
