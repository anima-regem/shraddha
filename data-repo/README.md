# Shraddha UPSC Content Repo

Content source for the Shraddha UPSC prep app. Push this folder to a public GitHub repo, then point the app to it in **Settings → Content Repository** using the raw base URL:

```
https://raw.githubusercontent.com/<user>/<repo>/<branch>
```

## Structure

```
manifest.json                    # schemaVersion, contentVersion, subject index
subjects/<subject-id>/
    subject.json                 # name, icon, color (#hex), topics[]
    flashcards.json              # { subjectId, cards: [...] }
    mcqs.json                    # { subjectId, questions: [...] }
```

## Adding content

1. Add cards/questions to the relevant JSON files (keep `id` unique, prefix with subject).
2. **Increment `contentVersion` in `manifest.json`** — the app only re-downloads when this changes.
3. Commit and push. Tap **Sync now** in the app.

## Schemas

Flashcard:

```json
{ "id": "pol-fc-001", "topic": "Constitution", "front": "...", "back": "...", "tags": ["optional"] }
```

MCQ (`answerIndex` is 0-based; `difficulty`: easy | medium | hard; `year` optional PYQ year):

```json
{ "id": "pol-mcq-001", "topic": "Parliament", "question": "...", "options": ["A", "B", "C", "D"], "answerIndex": 1, "explanation": "...", "difficulty": "medium", "year": 2019 }
```

Valid `icon` values: `account_balance`, `castle`, `public`, `trending_up`, `eco`, `rocket_launch`, `newspaper`, `menu_book`, `gavel`, `psychology`.
