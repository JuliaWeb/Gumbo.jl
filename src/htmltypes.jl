abstract HTMLNode

# TODO immutable?
type HTMLText <: HTMLNode
    parent::HTMLNode
    text::AbstractString
end

# convenience method for defining without parent
HTMLText(text::AbstractString) = HTMLText(NullNode(), text)

type NullNode <: HTMLNode end

type HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    parent::HTMLNode
    attributes::Dict{AbstractString,AbstractString}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}(HTMLNode[],NullNode(),Dict{AbstractString,AbstractString}())

type HTMLDocument
    doctype::AbstractString
    root::HTMLElement
end

type InvalidHTMLException <: Exception
    msg::AbstractString
end
