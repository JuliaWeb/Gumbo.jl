abstract HTMLNode

# TODO immutable?
type HTMLText <: HTMLNode
    parent::HTMLNode
    text::String
end

# convenience method for defining without parent
HTMLText(text::String) = HTMLText(NullNode(), text)

type NullNode <: HTMLNode end

type HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    parent::HTMLNode
    attributes::Dict{String, String}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}(HTMLNode[],NullNode(),Dict{String,String}())

type HTMLDocument
    doctype::String
    root::HTMLElement
end

type InvalidHTMLException <: Exception
    msg::String
end
