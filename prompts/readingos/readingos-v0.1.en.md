# ReadingOS v0.1: Codex Implementation Prompt (English)

- Prompt version: 1.0.0
- Prepared: 2026-10-11
- Target: ReadingOS v0.1 usable on a personal computer and suitable for a small friends-only trial
- Status: requirements and implementation brief; application acceptance has not been completed
- Equivalent Chinese version: [readingos-v0.1.zh-CN.md](readingos-v0.1.zh-CN.md)

> Give this task to Codex with access to a local development environment. Both language versions specify the same requirements; use either one. Inspect the environment and project first, then implement, validate, and deliver continuously. Do not stop at a proposal. The task is to build an application; the prompt-engineering repository containing this document stores prompts only.

## 1. Role, objective, and working method

Act as the product and engineering collaborator for this project. Implement ReadingOS v0.1 as a real application that the user can launch on their own computer, use to retain reading materials over time, and distribute to a few friends for testing.

Read applicable AGENTS.md files and existing documentation. Inspect existing ReadingOS projects and uncommitted changes. Preserve existing work: do not overwrite unrelated files, reset user changes, or force-push. If the current directory is only the prompts repository, create a separate application directory and Git repository. Do not put application source code, books, or local databases in prompt-engineering.

Inspect the operating system, architecture, Git, Node.js, package manager, disk space, network access, existing projects/remotes, and desktop build tooling before implementation. Windows is the primary target, with Simplified Chinese as the default UI language. Other desktop platforms are future compatibility targets. If considering Tauri, also inspect Rust, Windows C++ build tools, and WebView2; for Electron, inspect its runtime and packaging toolchain.

Present a short execution plan and start implementing. Make ordinary reversible engineering decisions independently and record reasons. Ask only when essential information is missing, an action would destroy existing data, or permissions are unavailable. When blocked, complete independent work first and report the exact blocker and an actionable next step. Never mark incomplete work as complete.

## 2. Agreed product position and scope

ReadingOS may eventually become a personal life management platform for schedules, journals, tasks, sleep, exercise, diet, and hydration. The current focus is the reading module. Launch directly into the library, without an empty life dashboard or a premature plugin platform.

The purpose of reading is to accumulate personal understanding and put it into practice, beyond opening files. The complete flow is:

Import a digital book or register a paper book → read and annotate → reading logs → pinned overall reflection → extract insights → practice and review.

This version is local-first, works offline, serves one user, and requires neither registration nor a server. Distributing the app does not distribute the user's personal data; friends receive independent libraries. Weather, motivational feeds, general calendars, diaries, life task management, health features, cloud sync, mobile apps, collaboration, and production AI functionality are outside v0.1.

P0/P1/P2 describe implementation order. After establishing the reliable P0 reading flow, include minimal insights, actions, plans, and statistics in v0.1. AI is deferred. If these minimal features remain unfinished, do not claim acceptance of the complete v0.1.

## 3. GitHub research and reuse strategy

The following official repository READMEs, licenses, and commit information were directly inspected on 2026-10-11. These are dependency candidates and references, not a combination already tested at runtime. Recheck relevant versions, compatibility, and licenses when implementation starts, and pin what is actually used.

| Project | Verified properties | Intended use |
| --- | --- | --- |
| [mozilla/pdf.js](https://github.com/mozilla/pdf.js) | PDF rendering and viewer; Apache-2.0; published package pdfjs-dist | Preferred PDF foundation; inspect annotation APIs and decide between viewer reuse and a custom annotation layer |
| [futurepress/epub.js](https://github.com/futurepress/epub.js) | Browser EPUB rendering, CFI, highlight examples; repository license has two BSD clauses | One leading EPUB candidate; validate selection, highlights, reflow anchors, and maintenance cost |
| [johnfactotum/foliate-js](https://github.com/johnfactotum/foliate-js) | MIT; EPUB, MOBI, KF8/AZW3, FB2, CBZ; PDF adapter explicitly experimental; README warns the API is unstable | Alternative EPUB candidate and foundation for future formats; pin a commit and wrap an adapter if used |
| [readest/readest](https://github.com/readest/readest) | Complete multi-format reader; README describes Next.js/Tauri; AGPL-3.0-or-later; handwriting remains a planned feature in the inspected README | Reference library, reading, navigation, and settings UX; do not assume a usable handwriting module exists |
| [koodo-reader/koodo-reader](https://github.com/koodo-reader/koodo-reader) | Complete cross-platform reader with multiple formats and note export; current LICENSE is AGPLv3 | Reference library, import/export, and desktop UX; do not label it MIT based on old material |

Research commit snapshots, for traceability rather than instructions to install development HEAD:

- PDF.js: 24176a9460ca69f4d2ea5df4577f5ac2302b6cc1
- EPUB.js: eee359d0790002115a1156a9833c54f4bcd44c1d
- foliate-js: 78914aef4466eb960965702401634c2cb348e9b1
- Readest: 385a322b8c1934375d02c50435b07c268d8ed3de
- Koodo Reader (dev): 1fd0cc7f151916447d396e0c8a2c036180992cab

Default to an original ReadingOS application shell using open-source reader libraries directly. Do not build PDF/EPUB parsers from scratch. Select one EPUB engine after a small comparison using real sample books; do not ship two engines merely to increase complexity.

Forking a complete project is an alternative. If forking or copying AGPL code, establish the corresponding license, source delivery, and retained notices first. Do not simply relicense copied code as MIT. By default, reference the product experience without copying application source. Retain required LICENSE/NOTICE material for actual dependencies and deliver THIRD_PARTY_NOTICES. An exhaustive repository survey is unnecessary.

## 4. Minimal technical approach

First evaluate TypeScript + React + Vite + Electron + SQLite: a unified frontend ecosystem suitable for mouse drawing, PDF.js/EPUB integration, and Windows packaging. If an existing project or environment makes Tauri a better fit, use a TypeScript frontend + Tauri + SQLite and explain the decision in architecture documentation. Select one desktop framework. Use supported, compatible versions and commit a lockfile; do not claim a version is “latest” from memory.

Maintain module boundaries for library, reader, annotations, notes, insights/actions, plans/stats, storage, and settings. Use a ReaderAdapter interface for opening, navigation, selection, annotations, and progress, with one built-in implementation per PDF/EPUB format. Settings should identify/select each format's default built-in reader. Show honestly when there is only one implementation. Optional opening in an external system reader cannot guarantee internal annotations or progress synchronization; do not promise it, and do not build an engine marketplace.

Store structured data in a database and managed originals/attachments in the application data directory. Storing the entire library only in localStorage or delivering only a browser development server does not meet final requirements. Handle SQLite driver/packaging compatibility; for native Electron modules, verify ABI/rebuild behavior and operation inside the installed package.

Apply protections appropriate to importing local books. In Electron, isolate preload code and expose a specific IPC allowlist; book content must not access Node or the filesystem. In Tauri, use minimal capabilities. Disable book scripts, restrict remote resources, isolate rendered content, configure CSP, and handle links safely. Bundle reading resources locally rather than depending on CDNs. Validate backup archive paths to prevent traversal. v0.1 does not bypass DRM or execute scripts embedded in imported files.

## 5. Library and book home

Provide book cards/list, import, paper-book registration, search by title/author/tags, and basic sorting. Treat each book as a personal folder containing title, author, cover, format or paper type, tags, reading status, progress, and last access. Allow manual metadata correction when extraction fails.

Opening a book should normally show its home page in this fixed order:

1. Overall reflection, pinned and visible without first opening the reader.
2. Continue reading for digital books; manual progress for paper books, without an empty reader.
3. Insights and practice actions.
4. Reading logs, filterable by date or chapter.
5. Annotations and excerpts, with navigation back to the original.

Implement the agreed option B: one continuously editable overall reflection + multiple optional reading logs + insight cards. Logs may be dated or organized by chapter. Users may write only a long final reflection; never require a log every session, a card for every note, or a rigid template.

Choose a maintainable editor supporting at least headings, paragraphs, lists, quotations, basic text colors, and autosave. Markdown storage with toolbar and preview is acceptable. Show saving/saved/failed states; retain content and allow retry on failure. Support export and simple revision recovery for both the overall reflection and logs, protecting long-lived notes from accidental overwrites.

## 6. Reading, import, and supported formats

PDF and EPUB are mandatory in v0.1; paper books need no electronic file. Add TXT/Markdown only if inexpensive and compatible with the core schedule; otherwise place them in the roadmap. MOBI/AZW3/FB2/CBZ are incremental extensions. Clearly reject unsupported formats rather than reporting false success. DRM decryption, OCR, and complex automatic conversion are out of scope.

Copy imported originals into the managed application directory, recording file hash and original name without modifying the source. Reading must continue if the source file is moved or deleted. For duplicates, offer reuse of an existing entry or a separate reading copy; do not automatically merge different book editions. Clean up incomplete imports and show understandable errors.

Shared capabilities: table of contents where present, bookmarks, saved/restored position, continue reading, basic in-book search where text exists, keyboard navigation, and collapsible sidebars. Gracefully handle missing contents, textless documents, and corrupt formats.

PDF needs page navigation, page jump, zoom, fit width, and a text layer for selection. Scanned PDFs remain readable and support region highlights, mouse drawings, and coordinate-based text notes. Explain that text selection/search is unavailable without a text layer. Do not implement PDF font preferences by rewriting its contents.

EPUB needs font family, size, line spacing, text color, background/theme, paginated or scrolling mode, text highlights, and typed notes. Use CFI or another stable book locator plus excerpt context for reflow navigation; screen page numbers are not permanent addresses. Validate basic Simplified Chinese text, chapters, images, footnotes, and links.

## 7. Annotations and mouse handwriting

The primary input is an ordinary mouse; a pen may be used occasionally, with no specified device. Reading/text selection is the default. PDF tools explicitly switch between reading, text highlight, region highlight, text note, pen, and eraser/selection. Esc returns to reading. Ordinary dragging must not draw by accident.

Required functionality:

- Highlight colors and opacity, note text colors, pen colors and width.
- Mouse-down/drag strokes for underlining, circles, and brief handwriting; use Pointer Events and pointer capture for movement beyond the interaction area.
- Click or select to open a typed-note editor, then display a marker and sidebar entry with edit/delete controls.
- Stroke selection or whole-stroke erasing, plus undo/redo within the current editing session.
- Save completed annotations immediately and restore after restart; visibly indicate tool and color state.
- Use available pen pressure for pointerType pen, with fixed width when pressure is unavailable. Do not claim device compatibility without real-device validation.

Persist PDF-native page coordinates or reversible normalized coordinates, accounting for CropBox, rotation, zoom, scroll, and HiDPI; never save only screen pixels. Text highlights retain page, rectangles/quads, and excerpt. Freehand annotations retain path points and styles rather than only screenshots. Never overwrite the original PDF.

Prototype the choice between PDF.js annotation capabilities and a custom layer before committing; document limitations. Application annotations in the database are authoritative. v0.1 does not require writing annotations into interoperable PDF files. Provide structured backups and note export, and explain that external PDF readers do not automatically see application annotations. Annotated-PDF export is optional and must not displace the core.

EPUB requires only text highlights and typed notes, without a handwriting canvas that attempts to follow reflow.

## 8. Connections among reflections, logs, annotations, insights, and actions

Annotation entries offer explicit actions to insert a reference into a reading log/overall reflection or extract an insight. Do not automatically add every annotation to reflections. Preserve original excerpt, book, locator, annotation ID, and the user's explanation. Notes should navigate back to the source, and annotations should show which records reference them.

Use stable IDs rather than untraceable copied strings. If an annotation is deleted, preserve the quoted snapshot and user-authored note, marking the source as deleted. For an unresolved location, show its status and excerpt without navigating to the wrong place. A replacement book edition gets a new file/version identity; never silently attach old annotations to a new file.

Minimal insight fields: title, personal understanding, source links, tags, created/updated timestamps. Allow editing and multiple sources from the same book. Minimal action fields: linked insight, concrete step, optional review date, status (to try/in progress/completed/paused), result, and reflection. Completing an action does not prove the underlying insight true.

When marking a book finished, encourage a summary and at least one takeaway to try, but allow “add later” and complete the status change. Avoid mandatory forms that interrupt reading. Paper books support manually entered page/chapter/excerpt references, without links to nonexistent electronic pages.

## 9. Data model, persistence, and backups

Design and implement a small explicit model. Table names may differ, but preserve the semantics:

- Book: stable ID, digital/paper type, title/author, tags, reading status.
- BookFile: format, relative path, hash, file/version identity.
- ReadingProgress / Bookmark: format-specific locator and timestamps.
- Annotation: BookFile reference, type, locator, style, excerpt, text/path.
- BookSummary / ReadingLog / NoteRevision: reflection, logs, recoverable revisions.
- Insight / SourceLink: personal insights and traceable sources.
- Action / ActionReview: actions and practice results.
- ReadingPlan / CompletionEvent: monthly/yearly plans, completion/rereading events.
- SchemaVersion / Settings: migrations and preferences.

Use migrations, foreign keys or equivalent constraints, transactions, and stable UUIDs. Paths are relative to the data directory; locator structures are versioned. Plans reference Book without creating duplicate books. Make ownership of notes across file formats/copies explicit.

Provide:

1. Per-book Markdown/JSON export of reflections, logs, insights, actions, and text annotations, retaining source information. Structured export preserves handwriting paths; do not pretend they are recognized text.
2. A complete ZIP backup with a consistent SQLite snapshot, correct WAL handling, originals, covers/attachments, annotations, settings, manifest, and schemaVersion. Exclude secrets, caches, and temporary files.
3. Restore into a new data directory or empty library is sufficient for v0.1; complex merging is unnecessary. Validate versions, paths, references, and hashes before switching to the restored data. Failure preserves existing data. Back up before upgrades and clearly reject unsupported future backup versions.

Closing/restarting, upgrading, and duplicate imports must not lose reflections, annotations, or progress. Perform a real backup → restore to a new directory → open the restored book and verify links exercise.

## 10. Reading plans and statistics

Implement a simple yearly target and monthly plans: annual desired completion count and books assigned to each month, with books allowed to continue across months. Support planned, reading, finished, paused/abandoned statuses and editable completion dates. Count paper and digital books equally.

Default monthly/yearly statistics count distinct books by completion date. Record rereads as separate completion events and display reread counts separately. Multiple files, multi-month plans, and multiple logs must not inflate completed-book totals. Preserve previous completion events when starting a reread. Show planned totals, actual completed totals, and books in progress; omit complex rankings and unverified reading-time estimates.

## 11. Future iterations and AI memory

Record these directions in docs/ROADMAP.md. For now, retain only stable data foundations:

- v0.2: reader UX improvements, more formats, search, feedback fixes, and reliable annotation export.
- Later AI: user-selected materials, assisted insight extraction, summaries of personal reflections, and cross-book connections; configurable providers, with the full core usable without AI configuration.
- Long-term AI memory derives from user-approved insights and practice reviews. Track sources, creation time, revisions, AI-proposed/user-confirmed status, and archival/deletion state. Changes in understanding should remain traceable. Do not treat generated summaries as personal beliefs.
- Do not introduce a vector database, cloud uploading of entire books, or fake “memory connected” features in v0.1. Future external requests must clearly show transmitted content; keep keys separately secured and outside library backups, logs, and Git.
- Later still: tasks, diaries, weather, habits, and health modules may reference action IDs. Do not build the full life platform now.

## 12. Implementation order, acceptance, and delivery

Work in runnable vertical slices, creating meaningful Git commits:

1. Environment/reference verification, short architecture decision, dependency license inventory, desktop shell, and persistence.
2. Library, electronic import, paper books, book home, and autosaved reflection/logs.
3. PDF reading/mouse annotation; EPUB reading/text annotation/reliable anchors.
4. Bidirectional references, insights, practice actions, minimal monthly/yearly plans and statistics.
5. Export/backup/restore, error handling, UI refinement, and Windows packaging acceptance.

Validate proportionately to risk: type checking, lint when configured, production build, focused tests for data/migrations/backup integrity, coordinate transformations, EPUB anchoring, and counting rules, plus at least one real end-to-end reading flow. Use generated or openly redistributable test materials; never commit paid books, private notes, or restricted full texts to GitHub.

Acceptance checklist:

- [ ] Launches on Windows; after dependency installation, books, annotation, and reflections work offline.
- [ ] Imports PDF/EPUB; after moving source files and restarting, books open and progress restores.
- [ ] Registers paper books with reflections/logs and no empty electronic reader.
- [ ] PDF colored text/region highlights, typed notes, mouse drawing, whole-stroke erasing, and undo/redo work.
- [ ] PDF annotations stay aligned through zoom, window resize, scroll, page rotation, and restart.
- [ ] EPUB highlights/notes remain correctly anchored after changing font size/window width and after restart.
- [ ] Reflections are pinned, logs are independent, and annotation references navigate back to sources.
- [ ] Insights/actions are editable; results are recorded; takeaways can be deferred when marking a book finished.
- [ ] Monthly/yearly statistics follow completion dates, cross-month plans, and documented reread rules.
- [ ] Autosave failures are visible without losing text; note revisions can be recovered.
- [ ] Markdown/JSON export and complete backup/restore are exercised; restored books, handwriting, and links remain intact.
- [ ] Corrupt files, textless PDFs, unsupported formats, missing attachments, and permission failures produce reasonable errors.
- [ ] Installer/executable distribution is tested in a clean Windows user environment; basic use requires no Node, Python, or development server. Runtime needs such as WebView2 are handled by installation/documentation.

Deliver source, lockfile, migrations, necessary tests, a Windows installer or executable distribution (prefer an .exe installer, with checksum), and:

- README: purpose, run/build commands, data location, backups, scope.
- docs/ARCHITECTURE.md, docs/RESEARCH.md with actual decisions/reference links, docs/ROADMAP.md.
- docs/ACCEPTANCE.md: actual per-item results, environment/date, and unverified items.
- docs/KNOWN_ISSUES.md, CHANGELOG.md, LICENSE, and THIRD_PARTY_NOTICES.
- Simplified Chinese trial guide and feedback template: reproduction steps, app version, operating system, expected/actual behavior, optional redacted screenshots.

If the environment cannot build or run Windows packages, distinguish “source runs,” “packaging configured,” “Windows package generated,” and “installed Windows package verified.” Prepare Windows CI and concrete next steps when useful, but never substitute Linux builds or web previews for Windows acceptance. Installation/uninstallation documentation must explain retention of user data.

Use a separate GitHub application repository, suggested name readingos. Inspect existing remotes and available permissions first; do not guess or overwrite a same-name project. The user has expressed intent to upload the eventual application to their GitHub. Commit/push when access is available and the target is unambiguous; otherwise finish local commits and provide exact commands without claiming an upload. Follow repository rules for source and release artifacts. Keep private libraries, backups, API keys, caches, node_modules, and databases out of Git. Explain v0.1 limitations before the friends trial. Publish a public Release only when that action is authorized in the implementation session.

Finish by reporting implemented features, actual validation evidence, launch/install instructions, distribution location, repository/commit, remaining problems, and next steps. Screenshots and demo data do not substitute for real persistence, annotation, and restore functionality.

