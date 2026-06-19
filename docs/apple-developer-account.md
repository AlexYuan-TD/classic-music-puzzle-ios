# Apple Developer Account Setup

You need an Apple Developer Program membership before uploading TestFlight builds or submitting to the App Store.

## Official Links

- Enrollment: https://developer.apple.com/programs/enroll/
- Program help: https://developer.apple.com/help/account/membership/program-enrollment/
- App Store Connect: https://developer.apple.com/app-store-connect/
- TestFlight: https://developer.apple.com/testflight/

## Cost

Apple lists the Apple Developer Program at 99 USD per membership year. Prices may vary by region and are shown in local currency during enrollment.

## Individual vs Organization

Individual:
- Easier for a solo developer.
- The seller/developer name on the App Store is your personal legal name.

Organization:
- Better if the app should be published under a company name.
- Usually requires organization verification, including legal entity information.

## What You Need

- Apple Account with two-factor authentication enabled.
- Legal name and contact information.
- Payment method for the annual membership fee.
- If enrolling as an organization: legal entity details and verification documents.

## Recommended Path For This App

If this is a personal free app, enroll as an Individual unless you specifically want the App Store seller name to be a company.

After enrollment:

1. Sign in to App Store Connect.
2. Create a new app record.
3. Use bundle ID: `com.jamesyyy.classicmusicpuzzle`.
4. Use app name: `Classic Music Journey`.
5. Add English and Simplified Chinese metadata from `docs/app-store-metadata.md`.
6. Add privacy answers from `docs/app-privacy-answers.md`.
7. Upload a TestFlight build from Xcode.
8. Preview TestFlight before submitting to App Review.

## Important

Do not submit to App Review until:

- The owner previews the app on a real device or simulator.
- `https://jamesyyy.com/classic-music-journey/` is live.
- App screenshots are created and approved.
- China ICP/app market plan is reviewed.

