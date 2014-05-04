type HTMLElement{T}
    children::Vector{HTMLElement}
    text::String
    attributes::Dict{String, String}
end

type HTMLDocument
    doctype::String
    root::HTMLElement
end

type InvalidHTMLException <: Exception
    msg::String
end
