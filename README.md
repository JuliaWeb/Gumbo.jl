# Gumbo.jl

[![Build Status](https://travis-ci.org/porterjamesj/Gumbo.jl.svg?branch=master)](https://travis-ci.org/porterjamesj/Gumbo.jl)

Gumbo.jl is Julia wrapper around
[Google's gumbo library](https://github.com/google/gumbo-parser) for
parsing HTML.

Getting started is very easy:


```julia
julia> using Gumbo

julia> parsehtml("<h1> Hello, world! </h1>")
HTML Document:
<!DOCTYPE >
HTMLElement{:HTML}:
<HTML>
  <head></head>
  <body>
    <h1>
       Hello, world!
    </h1>
  </body>
</HTML>
```

Read on for further documentation.

## Installation

On Unix systems you *should* be able to do:

```
Pkg.clone("https://github.com/porterjamesj/Gumbo.jl.git")
Pkg.build("Gumbo")
```

Please file an issue if the build script fails for you; it has not yet
been extensively tested.

Windows is not yet supported, mostly due to the difficulty of building
the gumbo C library on non-Unix platforms.

## Basic usage

The workhorse is the `parsehtml` function, which takes a single
argument, a valid UTF8 `String` (meaning it could be a `UTF8String` or
an `ASCIIString`, since all valid ASCII is also valid UTF8), which is
interpreted as HTML data to be parsed, e.g.:

```julia
parsehtml("<h1> Hello, world! </h1>")
```

The result of a call to `parsehtml` is an `HTMLDocument`, a type which
has two fields: `doctype`, which is the doctype of the parsed document
(this will be the empty string if no doctype is provided), and `root`,
which is a reference to the `HTMLElement` that is the root of the
document.

Note that gumbo is a very permissive HTML parser, designed to
gracefully handle the insanity that passes for HTML out on the wild,
wild web. It will return a valid HTML document for *any* input, doing
all sorts of algorithmic gymnastics to twist what you give it into
valid HTML.

If you want an HTML valdator, this is probably not your library. That
said, `parsehtml` does take an optional `Bool` keyword argument,
`strict` which, if `true`, causes an `InvalidHTMLError` to be thrown
if the call to the gumbo C library produces any errors.

## HTML types

This library defines a number of types for representing HTML.

### `HTMLDocument`

`HTMlDocument` is what is returned from a call to `parsehtml` it has a
`doctype` field, which contains the doctype of the parsed document,
and a `root` field, which is a reference to the root of the document.

### `HTMLNode`s

A document contains a tree of HTML Nodes, which are represented as
children of the `HTMLNode` abstract type. The first of these is
`HTMLElement`.

### `HTMLElement`

```julia
type HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    parent::HTMLNode
    attributes::Dict{String, String}
end
```

`HTMLElement` is probably the most interesting and frequently used
type. An `HTMLElement` is parameterized by a symbol representing its
tag. So an `HTMLElement{:a}` is a different type from an
`HTMLElement{:body}`, etc. An empty HTMLElement of a given tag can be
constructed as follows:

```julia
julia> HTMLElement(:div)
HTMLElement{:div}:
<div></div>
```

`HTMLElement`s have a `parent` field, which refers to another
`HTMLNode`. `parent` will always be an `HTMLElement`, unless the
element has no parent (as is the case with the root of a document), in
which case it will be a `NullNode`, a special type of `HTMLNode` which
exists for just this purpose. Empty `HTMLElement`s constructed as in
the example above will also have a `NullNode` for a parent.

`HTMLElement`s also have `children`, which is a vector of
`HTMLElement` containing the children of this element, and
`attributes`, which is a `Dict` mapping attribute names to values.

`HTMLElement`s implement `getindex`, `setindex!`, and `push!`;
indexing into or pushing onto an `HTMLElement` operates on its
children array.

There are a number of convenience methods for working with `HTMLElement`s:

- `tag(elem)`
  get the tag of this element as a symbol

- `attrs(elem)`
  return the attributes dict of this element

- `children(elem)`
   return the children array of this element

- `getattr(elem, name)`
  get the value of attribute `name` or raise a KeyError

- `setattr!(elem, name, value)`
  set the value of attribute `name` to `value`

### `HTMLText`

```
type HTMLText <: HTMLNode
    parent::HTMLNode
    text::String
end
```

Represents text appearing in an HTML document. For example:

```julia
julia> doc = parsehtml("<h1> Hello, world! </h1>")
HTML Document:
<!DOCTYPE >
HTMLElement{:HTML}:
<HTML>
  <head></head>
  <body>
    <h1>
       Hello, world!
    </h1>
  </body>
</HTML>

julia> doc.root[2][1][1]
HTML Text:  Hello, world!
```

This type is quite simple, just a reference to its parent and the
actual text it represents (this is also accessible by a `text`
function). You can construct `HTMLText` instances as follows:

```
julia> HTMLText("Example text")
HTML Text: Example text
```

Just as with `HTMLElement`s, the parent of an instance so constructed
will be a `NullNode`.


## TODOS

- support CDATA
- support Windows
