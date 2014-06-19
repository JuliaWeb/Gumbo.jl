using BinDeps

@BinDeps.setup

libgumbo = library_dependency("libgumbo")

provides(Sources,
         URI("http://jamesporter.me/static/julia/gumbo-1.0.tar.gz"),
         libgumbo,
         unpacked_dir="gumbo-1.0")

provides(BuildProcess,
         Autotools(libtarget="libgumbo.la"),
         libgumbo)

@BinDeps.install [:libgumbo => :libgumbo]
