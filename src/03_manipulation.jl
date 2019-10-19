# functions for accessing and manipulation HTML types
# elements

tag(elem::HTMLElement{T}) where {T} = T

attrs(elem::HTMLElement) = elem.attributes
function setattr!(elem::HTMLElement, name::AbstractString, value::AbstractString)
    elem.attributes[name] = value
end
getattr(elem::HTMLElement, name) = elem.attributes[name]
getattr(elem::HTMLElement, name, default) = get(elem.attributes, name, default)
getattr(f::Function, elem::HTMLElement, name) = get(f, elem.attributes, name)

children(elem::HTMLElement) = elem.children
children(elem::HTMLText) = ()

# indexing into an element indexes into its children
getindex(elem::HTMLElement,i) = getindex(elem.children,i)
setindex!(elem::HTMLElement,i,val) = setindex!(elem.children,i,val)

push!(elem::HTMLElement,val) = push!(elem.children, val)

# text

text(t::HTMLText) = t.text
