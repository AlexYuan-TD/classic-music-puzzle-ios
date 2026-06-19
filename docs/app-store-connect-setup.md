# App Store Connect Setup

Use the approved Apple Developer account to create the first App Store app record.

Do not commit Apple ID passwords, verification codes, certificates, or private keys to this repo.

## 1. Sign In

Open:

https://appstoreconnect.apple.com/

Sign in with the approved Apple Developer account.

## 2. Create Bundle ID

If App Store Connect asks you to create an identifier in Certificates, Identifiers & Profiles:

- Platform: iOS
- Description: Classic Music Journey
- Bundle ID type: Explicit
- Bundle ID: `com.jamesyyy.classicmusicjourney`
- Capabilities: keep defaults only for now

This app currently does not need iCloud, push notifications, Sign in with Apple, Game Center, HealthKit, payments, or background networking.

## 3. Create New App

In App Store Connect:

1. Go to `My Apps`.
2. Click `+`.
3. Choose `New App`.
4. Platform: iOS
5. Name: `Classic Music Journey`
6. Primary language: English, or Simplified Chinese if you prefer China-first submission.
7. Bundle ID: `com.jamesyyy.classicmusicjourney`
8. SKU: `classic-music-journey-ios`
9. User Access: Full Access

## 4. Fill App Information

Use:

- `docs/app-store-metadata.md`
- `docs/app-privacy-answers.md`

Suggested category:

- Primary: Music
- Secondary: Education

## 5. URLs

Before submission, publish:

`https://jamesyyy.com/classic-music-journey/`

Use it for:

- Support URL
- Privacy Policy URL

## 6. Pricing

Set the app to free.

No in-app purchases are planned for the first version.

## 7. TestFlight

After the app record and signing are ready:

1. Open the project in Xcode.
2. Select your developer team.
3. Archive the app.
4. Upload to App Store Connect.
5. Test through TestFlight before App Review.

## 8. Do Not Submit Yet

Submit only after:

- App runs on simulator or device.
- Screenshots are prepared.
- Support/privacy page is live.
- Owner previews the final build.
- China ICP/app market plan is reviewed.

