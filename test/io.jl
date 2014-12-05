
let
    doc = open("$testdir/example.html") do example
        example |> readall |> parsehtml
    end
    io = IOBuffer()
    print(io, doc)
    seek(io, 0)
    newdoc = io |> readall |> parsehtml
    @test newdoc == doc
end
