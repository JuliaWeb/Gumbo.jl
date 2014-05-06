# functions for accessing and manipulation HTML types

# elements

tag{T}(elem::HTMLElement{T}) = T

attrs(elem::HTMLElement) = elem.attributes
function setattr!(elem::HTMLElement, name::String, value::String)
    elem.attributes[name] = value
end
getattr(elem::HTMLElement, name) = elem.attributes[name]

children(elem::HTMLElement) = elem.children

# indexing into an element indexes into it's children
Base.getindex(elem::HTMLElement,i) = getindex(elem.children,i)
Base.setindex!(elem::HTMLElement,i,val) = setindex!(elem.children,i,val)

Base.push!(elem::HTMLElement,val) = push!(elem.children, val)


# text

text(t::HTMLText) = t.text

# TODO tree traversal functions
