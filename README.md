# Scratch

A tiny macOS scratchpad. A single window with traffic lights, a text area, and a Copy button. That's it.

## Behavior

- Paste, edit, type — whatever.
- **Copy** (or ⌘↩) — text → clipboard, window hides.
- Close the window — app keeps running in the dock.
- Click the dock icon (or ⌘Tab back) — window returns with the same contents.
- ⌘Q — fully quits.

Text persists across launches via `@AppStorage`. No preferences, no settings, no menu items beyond the standard.

Requires macOS 13 or later.

## Building

Needs Xcode 26+ and [xcodegen](https://github.com/yonaskolb/XcodeGen):

```sh
brew install xcodegen
./package.sh
```

`package.sh` regenerates `Scratch.xcodeproj` from `project.yml`, archives + signs the app with your Developer ID Application cert (Xcode auto-provisions one on first archive), then writes a drag-to-install installer to `~/Downloads/Scratch.dmg`.

Edit `DEVELOPMENT_TEAM` in `project.yml` to point at your own team ID before running.

## Project layout

| Path | What |
| --- | --- |
| `Sources/Scratch.swift` | The whole app — SwiftUI view + AppDelegate that intercepts window close. |
| `Scratch_Icon.icon` | Icon Composer source; compiles to both Liquid Glass `Assets.car` (macOS 26+) and legacy `.icns` (macOS 13–15). |
| `project.yml` | xcodegen spec. `Scratch.xcodeproj/` is generated, not committed. |
| `ExportOptions.plist` | Developer ID export options for `xcodebuild`. |
| `package.sh` | The build pipeline. |
