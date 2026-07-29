# Shraddha — UPSC Prep App

A fun, animated Flutter app for UPSC preparation: flashcards with spaced repetition, MCQ practice, timed Prelims-style mocks, and local progress tracking with a GitHub-style heatmap. Content syncs from a GitHub repo.

## Layout

- `app/` — Flutter application (Android-first)
- `data-repo/` — content source (flashcards + MCQs as JSON). Push this to GitHub and point the app at it (see `data-repo/README.md`)

## Run

```sh
cd app
flutter pub get
flutter run          # on a connected Android device/emulator
```

Build a release APK:

```sh
cd app
flutter build apk --release
```

## Features

- **Flashcards** — 3D flip cards, swipe right = Good / left = Again, SM-2 spaced repetition scheduling
- **Practice MCQs** — instant feedback, shake/pulse animations, explanations, haptics
- **Timed mocks** — UPSC Prelims marking (+2 / −0.67 / 0), countdown timer, question palette, animated score report with confetti
- **Progress** — GitHub-style activity heatmap, current & longest streaks, weekly chart, per-subject accuracy, weak-topic detection
- **Daily goal** — configurable target with an animated goal ring
- **Content sync** — Settings → paste your GitHub repo URL → Sync now. Bundled seed content works fully offline out of the box
- **Optional support** — Settings links to the source and Buy Me a Coffee, plus a separate ad page. No ads appear in study flows.

## Tech

Flutter · Riverpod · Drift (SQLite) · dio · flutter_animate · confetti · fl_chart · google_fonts · Google Mobile Ads

## Tests

```sh
cd app
flutter test         # SM-2 scheduler, scoring, streak/heatmap logic, content parsing
```

## Update content

1. Edit JSON in `data-repo/` (see schemas in `data-repo/README.md`)
2. Bump `contentVersion` in `manifest.json`
3. Push to GitHub → in-app **Sync now**

To refresh the *bundled* seed instead: copy `data-repo/` over `app/assets/seed/` and rebuild.

## Optional ads

Ads are deliberately isolated to **Settings → Support Shraddha → Watch optional ads**.
Development builds request Google's Android banner test ad; release builds use
the configured production unit. Before publishing a release, complete the
AdMob **Privacy & messaging** setup and the required Google Play privacy
disclosures.
