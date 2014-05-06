# comparison functions for HTML Nodes and Documents

# equality

Base.isequal(x::HTMLDocument, y::HTMLDocument) =
    isequal(x.doctype,y.doctype) && isequal(x.root,y.root)

Base.isequal(x::HTMLText,y::HTMLText) = isequal(x.text, y.text)

Base.isequal(x::HTMLElement, y::HTMLElement) =
    isequal(x.attributes,y.attributes) && isequal(x.children,y.children)


# hashing

function Base.hash(doc::HTMLDocument)
    bitmix(hash(HTMLDocument),bitmix(hash(doc.doctype), hash(doc.root)))
end

function Base.hash{T}(elem::HTMLElement{T})
    h = hash(HTMLElement)
    h = bitmix(h,hash(T))
    h = bitmix(h,hash(elem.attributes))
    for child in elem.children
        h = bitmix(h,hash(child))
    end
    return h
end


Base.hash(t::HTMLText) = bitmix(hash(HTMLText),hash(t.text))
