# App Store Submission Plan

This plan is for publishing Classic Music Journey with Apple Developer account `yd.y@163.com`.

## Prepared In This Repo

- App name: Classic Music Journey
- Bundle ID: `com.jamesyyy.classicmusicjourney`
- Version: `1.0`
- Build: `4`
- Apple Team ID configured in Xcode project: `47DCQ2U48C`
- Price: Free
- Primary category: Music
- Secondary category: Education
- Support URL: `https://jamesyyy.com/support.html`
- Privacy Policy URL: `https://jamesyyy.com/privacy.html`
- Marketing URL: `https://jamesyyy.com/`

## Recommended Availability

Launch regions:

- United States
- China mainland, if App Store Connect accepts the app without an ICP blocker

If China mainland shows an ICP warning or cannot be selected, submit United States first and add China mainland after the ICP filing is ready.

## China Mainland ICP Notes

Apple may require an Internet Content Provider Filing Number for some China mainland app listings. The ICP information in App Store Connect must match the MIIT filing metadata.

For the first release, keep the app offline-first:

- No account system
- No public posting
- No cloud sync
- No ads
- No analytics
- No payment
- No external streaming

This reduces the compliance surface while you prepare any required ICP filing for `jamesyyy.com` and the app operator.

## App Store Connect Steps

1. Sign in to App Store Connect with `yd.y@163.com`.
2. Go to My Apps.
3. Select New App.
4. Choose iOS.
5. Use app name `Classic Music Journey`.
6. Select bundle ID `com.jamesyyy.classicmusicjourney`.
7. Use SKU `classic-music-journey-ios`.
8. Set pricing to Free.
9. In Pricing and Availability, select United States and China mainland if available.
10. Add English and Simplified Chinese localizations.
11. Fill app metadata from `docs/app-store-metadata.md`.
12. Fill privacy answers from `docs/app-privacy-answers.md`.
13. Add age rating using the notes in `docs/app-store-metadata.md`.
14. Upload build `1.0 (4)` from Xcode.
15. Add screenshots after device/simulator capture.
16. Submit to TestFlight first.
17. Test on iPhone SE and at least one larger iPhone.
18. Submit for App Review after final preview approval.

## Xcode Archive Steps

These require full Xcode, not only Command Line Tools.

1. Open `ClassicMusicPuzzle.xcodeproj`.
2. In Xcode Settings, sign in with `yd.y@163.com`.
3. Select the Apple Developer team for `yd.y@163.com`.
4. Select target `ClassicMusicPuzzle`.
5. Confirm bundle ID `com.jamesyyy.classicmusicjourney`.
6. Confirm version `1.0` and build `4`.
7. Select Any iOS Device.
8. Choose Product > Archive.
9. In Organizer, choose Distribute App.
10. Select App Store Connect.
11. Upload.

## Review Notes

Use this in App Review Notes:

```text
Classic Music Journey is a free, offline-first classical music introduction app. It introduces composers through synthesized piano-style public-domain music themes, short bilingual introductions, historical portraits or color placeholders, inspirational quotes, and public-domain poem excerpts. The app does not require login, does not include payment, does not include ads, and does not track users. Listener reflections are stored locally on the device in this version.
```

For China mainland review context:

```text
The app is intended for educational and cultural appreciation of classical music. It does not provide public user posting, social networking, purchases, or account registration in this version.
```

## Reply for Guideline 4 Layout

Use this after uploading build `1.0 (6)`:

```text
Hello App Review,

Thank you for reviewing Classic Music Journey. We revised the app again to address the layout issue reported on iPad Air 11-inch running iPadOS 26.5.

In build 1.0 (6), iPad-width screens now use a dedicated two-column listening layout instead of stacking all sections vertically. The composer introduction and quote are placed in the left column, while the poem experience is placed in the right column, giving the text more room and reducing vertical crowding.

We also reduced oversized text and poem spacing across larger screens, added safer top and bottom spacing, and changed the Listening Guide, Reflection, and About sheets to open at full height so their content is easier to read and interact with.

Please review the updated build 1.0 (6).
```

## Final Manual Gate

Before clicking Submit for Review, confirm:

- The uploaded build opens correctly from TestFlight.
- Audio starts and stops correctly.
- English and Simplified Chinese are readable.
- iPhone SE layout fits the screen.
- Support and privacy URLs are live.
- The selected countries or regions are correct.
- China mainland ICP status has been checked in App Store Connect.
