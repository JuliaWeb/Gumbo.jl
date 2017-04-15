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

let res = Any[]
    for node in StatelessBFS(ex.root)
        push!(res, node)
    end
    @assert tag(res[3]) == :body
    @assert tag(res[4]) == :p
    @assert text(last(res)) == "b"
end

let res = Any[]
    for node in PreOrderDFS(ex.root)
        push!(res, node)
    end
    @assert tag(res[3]) == :body
    @assert tag(res[4]) == :p
    @assert text(last(res)) == "c"
end

let res = Any[]
    for node in PostOrderDFS(ex.root)
        push!(res, node)
    end
    @assert tag(res[1]) == :head
    @assert text(res[2]) == "a"
    @assert tag(res[4]) == :strong
    @assert tag(last(res)) == :HTML
end

isp(node::HTMLNode) = isa(node, HTMLElement) && tag(node) == :p

for itr in [PostOrderDFS, PreOrderDFS, StatelessBFS]
    @assert mapreduce(isp,+,itr(ex.root)) == 1
end
