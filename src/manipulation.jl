# functions for accessing and manipulation HTML types

# elements

tag{T}(elem::HTMLElement{T}) = T

attrs(elem::HTMLElement) = elem.attributes
function setattr!(elem::HTMLElement, name::String, value::String)
    elem.attributes[name] = value
end
getattr(elem::HTMLElement, name) = elem.attributes[name]

children(elem::HTMLElement) = elem.children

# TODO sometimes convenient but this should arguably be an error
# breadthfirst traversal will have to be updated
children(elem::HTMLNode) = HTMLNode[]

# indexing into an element indexes into it's children
Base.getindex(elem::HTMLElement,i) = getindex(elem.children,i)
Base.setindex!(elem::HTMLElement,i,val) = setindex!(elem.children,i,val)

Base.push!(elem::HTMLElement,val) = push!(elem.children, val)


# text

text(t::HTMLText) = t.text

# TODO tree traversal functions

abstract HTMLIterator

immutable PreOrderHTMLIterator <: HTMLIterator
    el::HTMLElement
end

immutable PostOrderHTMLIterator <: HTMLIterator
    el::HTMLElement
end

immutable BreadthFirstHTMLIterator <: HTMLIterator
    el::HTMLElement
end


preorder(el::HTMLElement) = PreOrderHTMLIterator(el)
postorder(el::HTMLElement) = PostOrderHTMLIterator(el)
breadthfirst(el::HTMLElement) = BreadthFirstHTMLIterator(el)

function traverse(itr::PreOrderHTMLIterator, el::HTMLElement)
    produce(el)
    for child in children(el)
        traverse(itr, child)
    end
end

function traverse(itr::PostOrderHTMLIterator, el::HTMLElement)
    for child in children(el)
        traverse(itr, child)
    end
    produce(el)
end

function traverse(itr::BreadthFirstHTMLIterator, el::HTMLElement)
    queue = HTMLNode[]
    push!(queue, el)
    while !isempty(queue)
        curr = shift!(queue)
        produce(curr)
        for child in children(curr)
            push!(queue, child)
        end
    end
end

traverse(itr, t::HTMLNode) = produce(t)

function Base.start(itr::HTMLIterator)
    t = @task traverse(itr, itr.el)
    return (t, start(t))
end

function Base.next(itr::HTMLIterator, state)
    t = state[1]
    ts = state[2]
    tv, ts = next(t, ts)
    return (tv, (t, ts))
end

function Base.done(itr::HTMLIterator, state)
    t = state[1]
    ts = state[2]
    return done(t, ts)
end
