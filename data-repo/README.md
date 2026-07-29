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
    <any nested folder>/
        flashcards-002.json      # { subjectId, cards: [...] }
        mcqs-002.json            # { subjectId, questions: [...] }
```

Shraddha recursively discovers files below each manifest subject folder in a
public GitHub repository. Only JSON filenames beginning with `flashcards` or
`mcqs` are imported; other JSON files are ignored. Keep `subject.json` at the
subject root.

Keep each content shard to roughly 100 cards or questions so it remains quick
to download on weak connections. This is a recommendation, not an app limit:
valid larger files still import. Every card and question ID must be globally
unique; prefixing IDs with the subject is recommended.

## Adding content

1. Add cards/questions to a `flashcards*.json` or `mcqs*.json` file anywhere
   beneath the relevant subject. Split files at roughly 100 entries.
2. **Increment `contentVersion` in `manifest.json`** — the app only re-downloads when this changes. A partial sync leaves the version incomplete and retries all shards next time.
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
