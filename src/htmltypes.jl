import AbstractTrees

abstract type HTMLNode end

mutable struct HTMLText <: HTMLNode
    parent::HTMLNode
    index_within_parent::Integer
    text::AbstractString
end

# convenience method for defining without parent
HTMLText(text::AbstractString) = HTMLText(NullNode(), 1, text)

struct NullNode <: HTMLNode end

mutable struct HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    parent::HTMLNode
    index_within_parent::Integer
    attributes::Dict{AbstractString,AbstractString}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}(HTMLNode[],NullNode(), 1, Dict{AbstractString,AbstractString}())

mutable struct HTMLDocument
    doctype::AbstractString
    root::HTMLElement
end

struct InvalidHTMLException <: Exception
    msg::AbstractString
end

# AbstractTrees interface declarations

AbstractTrees.ParentLinks(::Type{<:HTMLNode}) = AbstractTrees.StoredParents()
function AbstractTrees.parent(node::Union{HTMLElement,HTMLText})
    if node.parent isa NullNode
        return nothing
    else
        return node.parent
    end
end
AbstractTrees.parent(node::NullNode) = nothing

AbstractTrees.SiblingLinks(::Type{<:HTMLNode}) = AbstractTrees.StoredSiblings()

function AbstractTrees.nextsibling(node::Union{HTMLElement,HTMLText})
    if node.parent isa NullNode
        return nothing
    end
    num_siblings = length(node.parent.children)
    if node.index_within_parent < num_siblings
        return node.parent.children[node.index_within_parent + 1]
    else
        return nothing
    end
end

AbstractTrees.nextsibling(node::NullNode) = nothing

function AbstractTrees.prevsibling(node::Union{HTMLElement,HTMLText})
    if node.parent isa NullNode
        return nothing
    end
    if node.index_within_parent > 1
        return node.parent.children[node.index_within_parent - 1]
    else
        return nothing
    end
end

AbstractTrees.prevsibling(node::NullNode) = nothing
