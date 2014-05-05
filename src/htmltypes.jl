abstract HTMLNode

# TODO immutable?
type HTMLText <: HTMLNode
    text::String
end

type HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    attributes::Dict{String, String}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}({},Dict{String,String}())

type HTMLDocument
    doctype::String
    root::HTMLElement
end

type InvalidHTMLException <: Exception
    msg::String
end
