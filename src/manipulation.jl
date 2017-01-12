# functions for accessing and manipulation HTML types

import AbstractTrees
import Base: depwarn

# elements

tag{T}(elem::HTMLElement{T}) = T

attrs(elem::HTMLElement) = elem.attributes
function setattr!(elem::HTMLElement, name::AbstractString, value::AbstractString)
    elem.attributes[name] = value
end
getattr(elem::HTMLElement, name) = elem.attributes[name]


AbstractTrees.children(elem::HTMLElement) = elem.children

# TODO sometimes convenient but this should arguably be an error
# breadthfirst traversal will have to be updated
AbstractTrees.children(elem::HTMLNode) = HTMLNode[]

children = AbstractTrees.children

# indexing into an element indexes into its children
Base.getindex(elem::HTMLElement,i) = getindex(elem.children,i)
Base.setindex!(elem::HTMLElement,i,val) = setindex!(elem.children,i,val)

Base.push!(elem::HTMLElement,val) = push!(elem.children, val)


# text

text(t::HTMLText) = t.text

# tree traversals, deprecated wrappers around AbstractTrees

for (name, replacement) in [(:preorder, :PreOrderDFS),
                            (:postorder, :PostOrderDFS),
                            (:breadthfirst, :StatelessBFS)]
    @eval @deprecate $name(e::HTMLElement) AbstractTrees.$replacement(e)
    @eval function $name(f::Function, el::HTMLElement)
        for node in $name(el)
            f(node)
        end
    end
end
