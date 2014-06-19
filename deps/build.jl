using BinDeps

@BinDeps.setup

libgumbo = library_dependency("libgumbo", aliases = ["libgumbo-1"])

provides(Sources,
         URI("http://jamesporter.me/static/julia/gumbo-1.0.tar.gz"),
         libgumbo,
         unpacked_dir="gumbo-1.0")

provides(Binaries, URI("http://sourceforge.net/projects/juliadeps-win/files/gumbo-$(Sys.MACHINE).7z"),
         libgumbo, os = :Windows)

provides(BuildProcess,
         Autotools(libtarget="libgumbo.la"),
         libgumbo)

@BinDeps.install [:libgumbo => :libgumbo]
