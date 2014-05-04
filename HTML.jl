module HTML

import Gumbo

include("htmltypes.jl")

function parsehtml(input::String; strict=false)
    result_ptr = ccall((:gumbo_parse,"libgumbo"),
                       Ptr{Gumbo.Output},
                       (Ptr{Uint8},),
                       input)
    goutput::Gumbo.Output = unsafe_load(result_ptr)

    if strict && goutput.errors.length > 0
        throw(InvalidHTMLException("input html was invalid"))
    end
    document_from_gumbo(goutput)
end


function element(ge::Gumbo.Element)
    return Element{:test}(Element[],["test" =>"test"])
end


# transform gumbo output into Julia data
function document_from_gumbo(goutput::Gumbo.Output)
    # TODO convert some of these typeasserts to better error messages?
    gnode::Gumbo.Node = unsafe_load(goutput.document)
    if gnode.gntype != Gumbo.DOCUMENT
        error("Document appears to have incorrent GumboNodeType")
    end
    gdoc = reinterpret(Gumbo.Document,gnode.v)
    name = bytestring(gdoc.name)
    groot::Gumbo.Node = unsafe_load(goutput.root)
    if groot.gntype != Gumbo.ELEMENT  # should always be true
        error("root appears to have wrong GumboNodeType")
    end
    grootnode::Gumbo.Node = unsafe_load(goutput.root)
    root = element(grootnode.v)  # already an element
    Document(name, root)
end


end
