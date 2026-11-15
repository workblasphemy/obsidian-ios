# Obsidian for iOS — scaffold

**Status: never compiled.** This machine is Windows and cannot run Xcode, so the code below has only
been written, not built. The first real build happens in GitHub Actions (`.github/workflows/ios.yml`).

This is a **standalone project and repository**, deliberately separate from the Android app
(`music-player-m0`). Nothing here is shared with it except the intent and the visual language.

## What exists

| File | Purpose |
|---|---|
| `ObsidianApp/ObsidianApp.swift` | App entry, dark scheme, shared `PlayerEngine` + `LibraryStore` |
| `LibraryStore.swift` | Scans the app's Documents folder for audio files |
| `PlayerEngine.swift` | `AVPlayer` queue: play/pause, next/previous, seek, repeat-all, position ticker |
| `Views/LibraryView.swift` | Track list, `+` importer (system file picker, writes into Documents) |
| `Views/MiniPlayer.swift` | Bottom bar with title, artist and play/pause |
| `Views/NowPlayingView.swift` | Artwork placeholder, title, slider, transport |
| `project.yml` | XcodeGen spec — no `.xcodeproj` is committed |
| `.github/workflows/ios.yml` | Builds, screenshots the simulator, produces an unsigned `.ipa` |

## What it deliberately does not do yet

- No device-wide library scan (iOS does not allow one) — you import files, or drop them into the app
  folder via the Files app (`UIFileSharingEnabled` is on).
- No playlists, favourites, lyrics, theming, ribbons, widget.
- No YouTube/Spotify importer. That needs a server-side `yt-dlp` endpoint; the phone cannot do it.
- No artwork rendering yet (placeholder tile).

## How to get it on the phone

1. Push the repo; Actions runs `iOS` on a macOS runner and uploads `obsidian-ios` (an unsigned
   `.ipa` plus a simulator screenshot).
2. Download the artifact on Windows.
3. Sign and install with **Sideloadly** or **AltStore** using your Apple ID.
   Free provisioning expires after 7 days; re-sideload to renew.

## Local build (on a Mac)

```bash
brew install xcodegen
xcodegen generate
open Obsidian.xcodeproj
```
