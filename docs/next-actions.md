# Next Actions

## 1. Apple Developer Account

Apply for the Apple Developer Program first. See `docs/apple-developer-account.md`.

## 2. Xcode Build

On a Mac with full Xcode installed:

```sh
xcodegen generate
open ClassicMusicPuzzle.xcodeproj
```

Then:

- Select your Apple Developer team.
- Confirm bundle ID: `com.jamesyyy.classicmusicjourney`.
- Build and run on an iOS simulator.
- Test on a real iPhone if available.

## 3. Website

Publish `site/apple-audit-page/index.html` to:

`https://jamesyyy.com/classic-music-journey/`

Use that URL for Support URL and Privacy Policy URL in App Store Connect.

## 4. App Store Connect

After developer account approval:

- Create app record using `docs/app-store-connect-setup.md`.
- Add metadata from `docs/app-store-metadata.md`.
- Add privacy answers from `docs/app-privacy-answers.md`.
- Upload screenshots.
- Upload TestFlight build.
- Preview before App Review.

## 5. China Market

Before mainland China release:

- Review `docs/china-icp-and-app-market.md`.
- Confirm whether app filing / ICP-related steps apply for the operator and domain.
- Add required filing details to the public website if required.
