# Classic Music Rhythm

Free iOS app for introducing classical composers through short inspiring messages, famous public-domain musical themes, and a piano-key rhythm game with flowing staff notation.

## Product Shape

- Native SwiftUI iOS app.
- English and Simplified Chinese app content with an in-app language switcher.
- No ads, no accounts, no analytics, no tracking, and no in-app purchases.
- Composer pages include a short introduction, one inspiring message, a portrait, and a famous public-domain theme.
- The first catalog prepares 30 bilingual composer themes.
- A cute little dinosaur sits on the correct piano key and moves to the next key after each correct tap.
- Users can write a private reflection about what the music made them imagine or feel.
- Users swipe left or right to move to the previous or next composer page.
- On rhythm completion the app encourages the user to swipe to another composer.
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
