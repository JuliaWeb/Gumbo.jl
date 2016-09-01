
let
    doc = open("$testdir/example.html") do example
        example |> readstring |> parsehtml
    end
    io = IOBuffer()
    print(io, doc)
    seek(io, 0)
    newdoc = io |> readstring |> parsehtml
    @test newdoc == doc
end
