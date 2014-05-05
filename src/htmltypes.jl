type HTMLElement{T}
    children::Vector{HTMLElement}
    text::String
    attributes::Dict{String, String}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}({},"",Dict{String,String}())

type HTMLDocument
    doctype::String
    root::HTMLElement
end

type InvalidHTMLException <: Exception
    msg::String
end
