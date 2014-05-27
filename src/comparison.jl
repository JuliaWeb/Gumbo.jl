# comparison functions for HTML Nodes and Documents

# equality

Base.isequal(x::HTMLDocument, y::HTMLDocument) =
    isequal(x.doctype,y.doctype) && isequal(x.root,y.root)

Base.isequal(x::HTMLText,y::HTMLText) = isequal(x.text, y.text)

Base.isequal(x::HTMLElement, y::HTMLElement) =
    isequal(x.attributes,y.attributes) && isequal(x.children,y.children)

==(x::HTMLDocument, y::HTMLDocument) =
    ==(x.doctype,y.doctype) && ==(x.root,y.root)

==(x::HTMLText,y::HTMLText) = ==(x.text, y.text)

==(x::HTMLElement, y::HTMLElement) =
    ==(x.attributes,y.attributes) && ==(x.children,y.children)


# hashing

function Base.hash(doc::HTMLDocument)
    bitmix(hash(HTMLDocument),bitmix(hash(doc.doctype), hash(doc.root)))
end

function Base.hash{T}(elem::HTMLElement{T})
    h = hash(HTMLElement)
    h = bitmix(h,hash(T))
    h = bitmix(h,hash(attrs(elem)))
    for child in children(elem)
        h = bitmix(h,hash(child))
    end
    return h
end


Base.hash(t::HTMLText) = bitmix(hash(HTMLText),hash(t.text))
