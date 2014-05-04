module Gumbo

# immutable types corresponding to structs from
# gumbo.h

immutable Vector  # Gumbo vector
    data::Ptr{Ptr{Void}}
    length::Cuint
    capacity::Cuint
end

immutable StringPiece
    data::Ptr{Uint8}
    length::Csize_t
end

immutable SourcePosition
    line::Cuint
    column::Cuint
    offset::Cuint
end

immutable Text
    text::Ptr{Uint8}
    original_text::StringPiece
    start_pos::SourcePosition
end

# GumboNodeType enum

const DOCUMENT = int32(0)
const ELEMENT = int32(1)
const TEXT = int32(3)
const CDATA = int32(4)
const WHITESPACE = int32(5)

immutable Document
    children::Vector
    has_doctype::Bool
    name::Ptr{Uint8}
    public_identifier::Ptr{Uint8}
    system_identifier::Ptr{Uint8}
    doc_type_quirks_mode::Int32  # enum
end

immutable Attribute
    attr_namespace::Int32  # enum
    name::Ptr{Uint8}
    original_name::StringPiece
    value::Ptr{Uint8}
    original_value::StringPiece
    name_start::SourcePosition
    name_end::SourcePosition
    value_start::SourcePosition
    value_end::SourcePosition
end

immutable Element
    children::Vector
    tag::Int32  # enum
    tag_namespace::Int32  # enum
    original_tag::StringPiece
    original_end_tag::StringPiece
    start_pos::SourcePosition
    end_pos::SourcePosition
    attributes::Vector
end

immutable Node
    gntype::Int32  # enum
    parent::Ptr{Node}
    index_within_parent::Csize_t
    parse_flags::Int32  # enum
    v::Element  # might actually be something else
end

immutable Output
    document::Ptr{Node}
    root::Ptr{Node}
    errors::Vector
end

end
