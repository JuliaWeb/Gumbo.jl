# functions for accessing and manipulation HTML types

tag{T}(elem::HTMLElement{T}) = T
attrs(elem::HTMLElement) = elem.attributes
function setattr!(elem::HTMLElement, name::String, value::String)
    elem.attributes[name] = value
end
getattr(elem::HTMLElement, name) = elem.attributes[name]
children(elem::HTMLElement) = elem.children


# TODO tree traversal functions
