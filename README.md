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

The workhorse is the `parsehtml` method, which takes a single
argument, a valid UTF8 `String` (meaning it could be a `UTF8String` or
an `ASCIIString`, since all valid ASCII is also valid UTF8), which is
interpreted as `HTML` to be parsed, e.g.:

```julia
parsehtml("<h1> Hello, world! </h1>")
```

The result of a call to `parsehtml` is an `HTMLDocument`, a type which
has two fields: `doctype`, which is self-explanatory, and `root`,
which is a reference to the `HTMLElement` that is the root of the document.

Note that gumbo is a very permissive HTML parser, designed to
gracefully handle the insanity that passes for HTML out on the wild,
wild web. It will return a valid HTML document for *any* input, doing
all sorts of gymnastics to twist what you give it into looking like
valid HTML.

If you want an HTML valdator, this is probably not your library. That
said, `parsehtml` does take a keyword argument, `strict`, which will
cause an `InvalidHTMLError` to be thrown if the call to the gumbo C
library produces any errors.
