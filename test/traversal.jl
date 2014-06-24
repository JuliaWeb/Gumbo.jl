const ex = parsehtml("""
                     <html>
                     <head></head>
                     <body>
                     <p>a<strong>b</strong>c</p>
                     </body>
                     </html>
                     """)

let res = {}
    for node in breadthfirst(ex.root)
        push!(res, node)
    end
    @assert tag(res[3]) == :body
    @assert tag(res[4]) == :p
    @assert text(last(res)) == "b"
end

let res = {}
    for node in preorder(ex.root)
        push!(res, node)
    end
    @assert tag(res[3]) == :body
    @assert tag(res[4]) == :p
    @assert text(last(res)) == "c"
end

let res = {}
    for node in postorder(ex.root)
        push!(res, node)
    end
    @assert tag(res[1]) == :head
    @assert text(res[2]) == "a"
    @assert tag(res[4]) == :strong
    @assert tag(last(res)) == :HTML
end

isp(node::HTMLNode) = isa(node, HTMLElement) && tag(node) == :p

for itr in [postorder, preorder, breadthfirst]
    @assert mapreduce(isp,+,itr(ex.root)) == 1
end


# function arg form of traversals

let res = {}
    breadthfirst(ex.root) do node
        push!(res, node)
    end
    @assert tag(res[3]) == :body
    @assert tag(res[4]) == :p
    @assert text(last(res)) == "b"
end

let res = {}
    preorder(ex.root) do node
        push!(res, node)
    end
    @assert tag(res[3]) == :body
    @assert tag(res[4]) == :p
    @assert text(last(res)) == "c"
end

let res = {}
    postorder(ex.root) do node
        push!(res, node)
    end
    @assert tag(res[1]) == :head
    @assert text(res[2]) == "a"
    @assert tag(res[4]) == :strong
    @assert tag(last(res)) == :HTML
end
