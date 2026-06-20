# Classic Music Journey

Free iOS app for introducing classical composers through short poetic listening pages, famous public-domain musical themes, and immersive poem reveals.

## Product Shape

- Native SwiftUI iOS app.
- English and Simplified Chinese app content with an in-app language switcher.
- No ads, no accounts, no analytics, no tracking, and no in-app purchases.
- Composer pages include a short introduction, a portrait, a famous public-domain theme, and a matching poem.
- The first catalog prepares 30 bilingual composer themes.
- Chinese mode uses fitting classical Chinese poems; English mode uses public-domain Western poems.
- Users swipe left or right to move to the previous or next composer page.
- Poem lines gradually fade in as the music plays.
- The app includes an About James Yuan section linking to `https://www.jamesyyy.com`.
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

Public product preview page:

- `site/classic-music-journey/index.html`

Publish the product page under `https://jamesyyy.com/classic-music-journey/` before App Store submission, then use a stable support/privacy URL on `jamesyyy.com` for App Store Connect.

## China Release Notes

Before publishing to mainland China app markets, complete the China mobile app filing / ICP-related process. See:

- `docs/china-icp-and-app-market.md`

## Preview Gate

Do not submit to App Store Connect or any China app market until the owner previews and approves the app, store listing, screenshots, and audit page.
