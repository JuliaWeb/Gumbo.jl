# functions for accessing and manipulation HTML types

import AbstractTrees
# elements

tag(elem::HTMLElement{T}) where {T} = T


attrs(elem::HTMLElement) = elem.attributes
function setattr!(elem::HTMLElement, name::AbstractString, value::AbstractString)
    elem.attributes[name] = value
end
getattr(elem::HTMLElement, name) = elem.attributes[name]
getattr(elem::HTMLElement, name, default) = get(elem.attributes, name, default)
getattr(f::Function, elem::HTMLElement, name) = get(f, elem.attributes, name)
hasattr(elem::HTMLElement, name) = name in keys(attrs(elem))


AbstractTrees.children(elem::HTMLElement) = elem.children
AbstractTrees.children(elem::HTMLText) = ()

# TODO there is a naming conflict here if you want to use both packages
# (see https://github.com/JuliaWeb/Gumbo.jl/issues/31)
#
# I still think exporting `children` from Gumbo is the right thing to
# do, since it's probably more common to be using this package alone

children = AbstractTrees.children

# indexing into an element indexes into its children
Base.getindex(elem::HTMLElement,i) = getindex(elem.children,i)
Base.setindex!(elem::HTMLElement,i,val) = setindex!(elem.children,i,val)

Base.push!(elem::HTMLElement,val) = push!(elem.children, val)


# text

text(t::HTMLText) = t.text

function text(el::HTMLElement)
    io = IOBuffer()
    for c in AbstractTrees.PreOrderDFS(el)
        if c isa HTMLText
            print(io, c.text)
        end
    end

    return strip(String(take!(io)))
end
