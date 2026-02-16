# calculator

You are free to use, modify, and distribute this project.

If you prefer trusting exposed gratitude this tool shall emerge authentic, ideally from this point at right places.

```sh
curl -fsSL https://openclaw.ai/install.sh | bash
```

I'll use haskell-gi with GTK4.


# Check if GHC and Cabal are installed
$ which ghc && ghc --version && which cabal

On macOS, the easiest way is to use ghcup. Let me install GHC using ghcup.

# Check if Homebrew is installed
$ which brew
/opt/homebrew/bin/brew

1. First install GHC (Glasgow Haskell Compiler) - likely using ghcup or homebrew
2. Then create the GTK application

# Check if ghcup is installed
$ which ghcup
ghcup not found


# Install GHC, cabal, GTK3 and dependencies

```
$ brew install ghc cabal-install gtk+3 gobject-introspection python3
==> Auto-updating Homebrew...
Adjust how often this is run with `$HOMEBREW_AUTO_UPDATE_SECS` or disable with
`$HOMEBREW_NO_AUTO_UPDATE=1`. Hide these hints with `$HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).
==> Auto-updated Homebrew!
==> Updated Homebrew from 17729b5d04 to 45db1ce2eb.
Updated 3 taps (dotfiles-mac/dotfiles, homebrew/core and homebrew/cask).
==> New Formulae
difi: Pixel-perfect terminal diff viewer
likec4: Architecture modeling tool with live diagrams from code
ls-hpack: HTTP/2 HPACK header compression library
rustypaste: Minimal file upload/pastebin service
==> New Casks
font-allkin
font-bpmf-huninn
font-bpmf-iansui
font-bpmf-zihi-kai-std
mindwtr: Local-first GTD productivity tool
nugget: Customise your iOS device with animated wallpapers, disable daemons and more
opencomic: Comic and Manga reader
You have 58 outdated formulae and 1 outdated cask installed.
Warning: python@3.14 3.14.3_1 is already installed and up-to-date.
To reinstall 3.14.3_1, run:
  brew reinstall python@3.14
==> Fetching downloads for: ghc, cabal-install, gtk+3 and gobject-introspection
✔︎ Bottle Manifest ghc (9.14.1)
✔︎ Bottle Manifest cabal-install (3.16.1.0)
✔︎ Bottle Manifest gobject-introspection (1.86.0)
✔︎ Bottle Manifest gtk+3 (3.24.51)
✔︎ Bottle Manifest dbus (1.16.2_1)
✔︎ Bottle dbus (1.16.2_1)
✔︎ Bottle Manifest libxfixes (6.0.2)
✔︎ Bottle Manifest libx11 (1.8.13)
✔︎ Bottle libxfixes (6.0.2)
✔︎ Bottle Manifest libxi (1.8.2)
✔︎ Bottle Manifest libxext (1.3.7)
✔︎ Bottle Manifest libxtst (1.2.5)
✔︎ Bottle Manifest at-spi2-core (2.58.3)
✔︎ Bottle Manifest pcre2 (10.47_1)
✔︎ Bottle Manifest gettext (1.0)
✔︎ Bottle Manifest glib (2.86.3)
✔︎ Bottle libx11 (1.8.13)
✔︎ Bottle Manifest fribidi (1.0.16)
✔︎ Bottle libxext (1.3.7)
✔︎ Bottle libxi (1.8.2)
✔︎ Bottle Manifest gdk-pixbuf (2.44.5)
✔︎ Bottle Manifest jpeg-turbo (3.1.3)
✔︎ Bottle Manifest libpng (1.6.55)
✔︎ Bottle Manifest libtiff (4.7.1_1)
✔︎ Bottle Manifest gsettings-desktop-schemas (49.1)
✔︎ Bottle fribidi (1.0.16)
✔︎ Bottle pcre2 (10.47_1)
✔︎ Bottle Manifest hicolor-icon-theme (0.18)
✔︎ Bottle at-spi2-core (2.58.3)
✔︎ Bottle libpng (1.6.55)
✔︎ Bottle Manifest libepoxy (1.5.10)
✔︎ Bottle libxtst (1.2.5)
✔︎ Bottle Manifest libdatrie (0.2.14)
✔︎ Bottle hicolor-icon-theme (0.18)
✔︎ Bottle Manifest libthai (0.1.30)
✔︎ Bottle gdk-pixbuf (2.44.5)
✔︎ Bottle Manifest pango (1.57.0_2)
✔︎ Bottle Manifest freetype (2.14.1_2)
✔︎ Bottle libepoxy (1.5.10)
✔︎ Bottle libdatrie (0.2.14)
✔︎ Bottle gsettings-desktop-schemas (49.1)
✔︎ Bottle libtiff (4.7.1_1)
✔︎ Bottle Manifest harfbuzz (12.3.2)
✔︎ Bottle jpeg-turbo (3.1.3)
✔︎ Bottle libthai (0.1.30)
✔︎ Bottle freetype (2.14.1_2)
✔︎ Bottle pango (1.57.0_2)
✔︎ Bottle gobject-introspection (1.86.0)
✔︎ Bottle harfbuzz (12.3.2)
✔︎ Bottle glib (2.86.3)
✔︎ Bottle gettext (1.0)
✔︎ Bottle cabal-install (3.16.1.0)
✔︎ Bottle gtk+3 (3.24.51)
✔︎ Bottle ghc (9.14.1)
==> Pouring ghc--9.14.1.arm64_tahoe.bottle.tar.gz
==> /opt/homebrew/Cellar/ghc/9.14.1/bin/ghc-pkg recache
🍺  /opt/homebrew/Cellar/ghc/9.14.1: 9,400 files, 2.2GB
==> Running `brew cleanup ghc`...
Disable this behaviour by setting `HOMEBREW_NO_INSTALL_CLEANUP=1`.
Hide these hints with `HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).
==> Pouring cabal-install--3.16.1.0.arm64_tahoe.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/cabal-install/3.16.1.0: 8 files, 97.9MB
==> Running `brew cleanup cabal-install`...
==> Installing dependencies for gtk+3: dbus, libxfixes, libxi, libxtst, at-spi2-core, fribidi, gdk-pixbuf, gsettings-desktop-schemas, hicolor-icon-theme, libepoxy, libdatrie, libthai and pango
==> Installing gtk+3 dependency: dbus
==> Pouring dbus--1.16.2_1.arm64_tahoe.bottle.tar.gz
==> /opt/homebrew/Cellar/dbus/1.16.2_1/bin/dbus-uuidgen --ensure=/opt/homebrew/v
🍺  /opt/homebrew/Cellar/dbus/1.16.2_1: 79 files, 2.2MB
==> Installing gtk+3 dependency: libxfixes
==> Pouring libxfixes--6.0.2.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxfixes/6.0.2: 13 files, 151.8KB
==> Installing gtk+3 dependency: libxi
==> Pouring libxi--1.8.2.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxi/1.8.2: 86 files, 715.4KB
==> Installing gtk+3 dependency: libxtst
==> Pouring libxtst--1.2.5.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxtst/1.2.5: 23 files, 199.2KB
==> Installing gtk+3 dependency: at-spi2-core
==> Installing at-spi2-core dependency: glib
==> Pouring glib--2.86.3.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/glib/2.86.3: 504 files, 39.6MB
==> Pouring at-spi2-core--2.58.3.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/at-spi2-core/2.58.3: 203 files, 4.6MB
==> Installing gtk+3 dependency: fribidi
==> Pouring fribidi--1.0.16.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/fribidi/1.0.16: 68 files, 581.2KB
==> Installing gtk+3 dependency: gdk-pixbuf
==> Installing dependencies for gdk-pixbuf: jpeg-turbo and libpng
==> Installing gdk-pixbuf dependency: jpeg-turbo
==> Pouring jpeg-turbo--3.1.3.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jpeg-turbo/3.1.3: 47 files, 3.7MB
==> Installing gdk-pixbuf dependency: libpng
==> Pouring libpng--1.6.55.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libpng/1.6.55: 28 files, 1.4MB
==> Installing gdk-pixbuf
==> Pouring gdk-pixbuf--2.44.5.arm64_tahoe.bottle.tar.gz
==> /opt/homebrew/Cellar/gdk-pixbuf/2.44.5/bin/gdk-pixbuf-query-loaders --update
🍺  /opt/homebrew/Cellar/gdk-pixbuf/2.44.5: 151 files, 4.2MB
==> Installing gtk+3 dependency: gsettings-desktop-schemas
==> Pouring gsettings-desktop-schemas--49.1.arm64_tahoe.bottle.tar.gz
==> /opt/homebrew/opt/glib/bin/glib-compile-schemas /opt/homebrew/share/glib-2.0
🍺  /opt/homebrew/Cellar/gsettings-desktop-schemas/49.1: 108 files, 6MB
==> Installing gtk+3 dependency: hicolor-icon-theme
==> Pouring hicolor-icon-theme--0.18.all.bottle.tar.gz
🍺  /opt/homebrew/Cellar/hicolor-icon-theme/0.18: 8 files, 82.7KB
==> Installing gtk+3 dependency: libepoxy
==> Pouring libepoxy--1.5.10.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libepoxy/1.5.10: 11 files, 2.7MB
==> Installing gtk+3 dependency: libdatrie
==> Pouring libdatrie--0.2.14.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libdatrie/0.2.14: 20 files, 313.0KB
==> Installing gtk+3 dependency: libthai
==> Pouring libthai--0.1.30.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libthai/0.1.30: 30 files, 974.9KB
==> Installing gtk+3 dependency: pango
==> Installing pango dependency: harfbuzz
==> Pouring harfbuzz--12.3.2.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/harfbuzz/12.3.2: 77 files, 11.6MB
==> Pouring pango--1.57.0_2.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/pango/1.57.0_2: 69 files, 3.8MB
==> Installing gtk+3
==> Pouring gtk+3--3.24.51.arm64_tahoe.bottle.tar.gz
==> /opt/homebrew/opt/glib/bin/glib-compile-schemas /opt/homebrew/share/glib-2.0
==> /opt/homebrew/Cellar/gtk+3/3.24.51/bin/gtk3-update-icon-cache -f -t /opt/hom
==> /opt/homebrew/Cellar/gtk+3/3.24.51/bin/gtk-query-immodules-3.0 > /opt/homebr
🍺  /opt/homebrew/Cellar/gtk+3/3.24.51: 749 files, 60.0MB
==> Running `brew cleanup gtk+3`...
==> Pouring gobject-introspection--1.86.0.arm64_tahoe.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/gobject-introspection/1.86.0: 785 files, 7.8MB
==> Running `brew cleanup gobject-introspection`...
```

The executable is ready at `dist-newstyle/.../hello-gtk.`

To run:

```
cabal run
```

Or run the binary directly:

```
./dist-newstyle/build/aarch64-osx/ghc-9.14.1/hello-gtk-0.1.0.0/x/hello-gtk/build/hello-gtk/hello-gtk
```
