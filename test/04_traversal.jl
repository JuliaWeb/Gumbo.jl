using AbstractTrees

# TODO these tests are pretty silly in that they now pretty much just
# test code in AbstractTrees.jl. They are still sort of useful though
# in that they test our implementation of `children` indirectly, and I
# an just loath to remove tests in general, so I'm going to leave them
# here for now

const ex = parsehtml("""
                     <html>
                     <head></head>
                     <body>
                     <p>a<strong>b</strong>c</p>
                     </body>
                     </html>
                     """)

@testset "StatelessBFS" begin
    res = collect(StatelessBFS(ex.root))
    @test tag(res[3]) == :body
    @test tag(res[4]) == :p
    @test text(last(res)) == "b"
end
@testset "PreOrderDFS" begin
    res = collect(PreOrderDFS(ex.root))
    @test tag(res[3]) == :body
    @test tag(res[4]) == :p
    @test text(last(res)) == "c"
end
@testset "PostOrderDFS" begin
    res = collect(PostOrderDFS(ex.root))
    @test tag(res[1]) == :head
    @test text(res[2]) == "a"
    @test tag(res[4]) == :strong
    @test tag(last(res)) == :HTML
end

isp(node::HTMLNode) = isa(node, HTMLElement) && tag(node) == :p

@testset begin
    for itr in [PostOrderDFS, PreOrderDFS, StatelessBFS]
        @test count(isp, itr(ex.root)) == 1
    end
end
