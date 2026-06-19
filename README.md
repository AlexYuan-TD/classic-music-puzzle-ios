# Classic Music Rhythm

Free iOS app for introducing classical composers through short inspiring messages, famous public-domain musical themes, and a piano-key rhythm game with flowing staff notation.

## Product Shape

- Native SwiftUI iOS app.
- No ads, no accounts, no analytics, no tracking, and no in-app purchases.
- Composer pages include a short introduction, one inspiring message, a portrait, and a famous public-domain theme.
- Rhythm levels progress from easy to hard with more key taps and faster flowing staff notes.
- On rhythm completion the user can stay, replay, or go to the next level.
- Music playback uses synthesized note data instead of bundled recordings to avoid separate recording rights.

## Local Setup

The Xcode project is included. It can also be regenerated with XcodeGen.

```sh
brew install xcodegen
xcodegen generate
open ClassicMusicPuzzle.xcodeproj
```

Then select a development team in Xcode and run on an iOS simulator or device.

## Apple Review URLs

Draft audit, support, and privacy page:

- `site/apple-audit-page/index.html`

Publish this content under `https://jamesyyy.com/classic-music-rhythm/` before App Store submission, then use that URL for the App Store Connect Support URL and Privacy Policy URL.

## China Release Notes

Before publishing to mainland China app markets, complete the China mobile app filing / ICP-related process. See:

- `docs/china-icp-and-app-market.md`

## Preview Gate

Do not submit to App Store Connect or any China app market until the owner previews and approves the app, store listing, screenshots, and audit page.
