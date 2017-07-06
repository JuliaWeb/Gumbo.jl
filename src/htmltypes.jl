abstract type HTMLNode end

struct HTMLText <: HTMLNode
    parent::HTMLNode
    text::AbstractString
end

# convenience method for defining without parent
HTMLText(text::AbstractString) = HTMLText(NullNode(), text)

struct NullNode <: HTMLNode end

mutable struct HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    parent::HTMLNode
    attributes::Dict{AbstractString,AbstractString}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}(HTMLNode[],NullNode(),Dict{AbstractString,AbstractString}())

mutable struct HTMLDocument
    doctype::AbstractString
    root::HTMLElement
end

struct InvalidHTMLException <: Exception
    msg::AbstractString
end
