# comparison functions for HTML Nodes and Documents

# equality

Base.isequal(x::HTMLDocument, y::HTMLDocument) =
    isequal(x.doctype,y.doctype) && isequal(x.root,y.root)

Base.isequal(x::HTMLText,y::HTMLText) = isequal(x.test, y.text)

Base.isequal(x::HTMLElement, y::HTMLElement) =
    isequal(x.attributes,y.attributes) && isequal(x.children,y.children)


# hashing

hash(doc::HTMLDocument) = bitmix(hash(doc.doctype), hash(doc.root))

hash(elem::HTMLElement) = bitmix(hash(tag(elem),
                                      mapreduce(hash,bitmix,elem.children)))

hash(t::HTMLText) = bitmix(hash(HTMLText),hash(t.text))
