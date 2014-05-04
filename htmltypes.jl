type Element{T}
    children::Vector{Element}
    attributes::Dict
end

type Document
    name::String
    root::Element
end


type InvalidHTMLException <: Exception
    msg::String
end
