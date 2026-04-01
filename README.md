# calculator

[![Release](https://github.com/bniladridas/calculator/actions/workflows/release.yml/badge.svg)](https://github.com/bniladridas/calculator/actions)

<img src="https://raw.githubusercontent.com/bniladridas/calculator/main/GUI/app-icon.png" width="64" style="border-radius:12px;box-shadow:0 2px 4px rgba(0,0,0,0.2);" align="right">

**Version:** 0.1.2.0

**Download:** [Latest Release](https://github.com/bniladridas/calculator/releases/latest)

**Tracked by:** [glimegtk](https://github.com/glimegtk)

A small calculator built with `haskell-gi`, `GTK4`, and `Gio`.

## Screenshots

| Main Window | About Dialog |
|:--:|:--:|
| <img src="https://raw.githubusercontent.com/bniladridas/calculator/main/GUI/calculator-main-window.png" width="260"> | <img src="https://raw.githubusercontent.com/bniladridas/calculator/main/GUI/calculator-about-dialog.png" width="260"> |

| App In Applications |
|:--:|
| <img src="https://raw.githubusercontent.com/bniladridas/calculator/main/GUI/calculator-applications-view.png" width="520"> |

## Build

On macOS, install the toolchain and GTK dependencies first:

```sh
brew install ghc cabal-install gtk4 gobject-introspection
```

Then build or run the app:

```sh
cabal build hello-gtk
cabal run hello-gtk
```

You can also run the built binary directly:

```sh
$(cabal list-bin hello-gtk)
```

## macOS Bundle

Create the app bundle with:

```sh
./scripts/create-bundle.sh
open Calculator.app
```

The bundle script now handles the macOS-specific packaging details that caused the earlier issues:

- it writes the correct bundle metadata instead of the old `com.example.Calculator` placeholder
- it uses `CFBundleIconFile = icon.icns` for Finder, Dock, and Launchpad
- it keeps a separate `icon.png` in the bundle resources for the in-app About dialog
- it rebuilds the `.app` from scratch so stale resources do not leak into a new bundle

The bundle icon source is [`GUI/icon.icns`](GUI/icon.icns), and the About dialog logo comes from [`GUI/app-icon.png`](GUI/app-icon.png).

## About And Settings Fix

The macOS app menu originally showed disabled `About Calculator` and `Settings...` items because the application did not register those actions. The GTK app now installs explicit `Gio.SimpleAction`s for:

- `app.about`
- `app.preferences`
- `app.quit`

That fixed two user-visible problems:

- `About Calculator` now opens a real GTK About dialog with version, repo link, and logo
- `Settings...` now opens a GTK settings window instead of staying disabled

The relevant logic is in [`Main.hs`](Main.hs).

## Project Files

- [`Main.hs`](Main.hs): GTK application, calculator UI, app actions
- [`scripts/create-bundle.sh`](scripts/create-bundle.sh): macOS `.app` packaging
- [`hello-gtk.cabal`](hello-gtk.cabal): package metadata and dependencies
