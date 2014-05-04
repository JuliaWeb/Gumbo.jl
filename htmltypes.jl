type Element{T}
    children::Vector{Element}
    text::String
    attributes::Dict{String, String}
end

type Document
    name::String
    root::Element
end


type InvalidHTMLException <: Exception
    msg::String
end
