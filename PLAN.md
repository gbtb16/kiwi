# kiwi — recovery plan

Derived from `AUDIT-2026-07.md`. Ordered by *user impact per hour spent*, not by
how interesting the work is.

Read this as three separate deliveries. **Phase 1 is the only one with a
deadline.** Phases 2 and 3 are backlog — do not let them into Phase 1's PR.

```
Phase 1  ~2-3 days   Ship kiwi_generator 5.0.0. Users can install again.
Phase 2  ~1 day      Make CI able to catch this class of failure.
Phase 3  ~2 days     Docs, community health, core-package polish.
Later               6.0.0 API decisions. Not scheduled.
```

---

# Phase 1 — kiwi_generator 5.0.0 (the only urgent one)

**Goal:** a user can add `kiwi_generator` to a 2026 Flutter app that already has
`freezed` / `json_serializable`, and `dart pub get` succeeds.

**Branch:** `feat/generator-v5-modern-build-stack`

### Step 1.1 — Delete the private import (5 min, already verified)

`packages/kiwi_generator/lib/src/kiwi_injector_generator.dart:5`

```dart
import 'package:build/src/builder/build_step.dart';   // ← delete this line
```

`BuildStep` is already exported by `package:build/build.dart` on line 4.
I removed it locally and confirmed `dart analyze --fatal-warnings .` stays clean
and all 10 tests pass. Do this first so it isn't tangled in the migration diff.

### Step 1.2 — Raise the SDK floor (10 min)

`packages/kiwi_generator/pubspec.yaml`:

```yaml
environment:
  sdk: '^3.5.0'     # was: '>=2.14.0 <4.0.0'
```

This is what makes 5.0.0 a **major** bump. Do it deliberately and say so in the
CHANGELOG — don't let it look like an accident. Modern `analyzer` / `build`
require it; there is no way to keep 2.14 support.

Leave `packages/kiwi`'s floor alone for now (see Phase 3.4).

### Step 1.3 — Let pub pick the versions, don't hand-pick them (20 min)

```bash
cd packages/kiwi_generator
dart pub upgrade --major-versions
git diff pubspec.yaml
```

Do **not** type `analyzer: ^14.0.0` from memory. `source_gen` and `build` each
constrain `analyzer` tightly; let the solver find the consistent set, then read
back what it chose. Expect roughly `analyzer ^8-10`, `source_gen ^4`,
`build ^4`, `dart_style ^3`, `build_runner ^2.15`, `build_test ^3.5`.

Then run `dart analyze` and treat the error list as your migration checklist.

### Step 1.4 — Migrate the generator (the actual work, ~1 day)

236 lines, four mechanical clusters. **Verify every API name against the
analyzer version pub actually resolved** — the element model was rewritten in
analyzer 7 (`*Element2`) and renamed again in 8+, so anything I quote from
memory is a starting point, not gospel.

| Location | What changes |
|---|---|
| `:14` | `TypeChecker.fromRuntime(Register)` → `TypeChecker.typeNamed(...)`. `fromRuntime` is gone in source_gen 2+. |
| `:16`, `:28-35`, `:60-75`, `:202-228` | Element model: `ClassElement` / `MethodElement` / `ConstructorElement` / `ParameterElement`, and `.methods` / `.parameters` / `.element` / `.getClass()`. Names and some accessors moved. |
| `:83`, `:162-165`, `:219-227` | `getDisplayString(withNullability: …)` — the parameter was **removed**. Drop it. See the note below. |
| `:45` | `DartFormatter()` → `DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)`. This is the exact thing blocking PR #126. |

**Note on `withNullability: false`.** Today the generator strips nullability, so
a constructor param `Foo? foo` emits `c.resolve<Foo>()`. That is *correct*
behaviour for kiwi (you register `Foo`, not `Foo?`). When the flag disappears
the default becomes "include nullability", which would emit `c.resolve<Foo?>()`
and **break resolution at runtime**. You must explicitly strip the `?` yourself.

Add a golden test for this before you touch it:

```
packages/kiwi_generator/test/inputs/nullable_constructor_param.dart
```

with a class taking `Foo? foo`, asserting the output is `c.resolve<Foo>()`.
Right now nothing in the suite covers it, so the migration could silently
regress it.

### Step 1.5 — Regenerate examples and verify (1-2 h)

```bash
cd examples/dart_kiwi     && dart pub get && dart run build_runner build --delete-conflicting-outputs
cd examples/flutter_kiwi  && flutter pub get && dart run build_runner build --delete-conflicting-outputs
git diff -- '*.g.dart'
```

`git diff` on the `.g.dart` files should be **empty**. If it isn't, the
migration changed generator output — read every line of that diff before
accepting it.

You will also need to bump the examples' SDK floors and their
`kiwi_generator: ^4.2.0` dev-dependency to `^5.0.0`.

### Step 1.6 — The resolution proof (30 min)

This is the step that actually confirms the bug is fixed. It must be done
**outside** the repo, with **no** `dependency_overrides`:

```bash
mkdir /tmp/kiwi-resolve && cd /tmp/kiwi-resolve
dart create -t console .
```

`pubspec.yaml`:

```yaml
environment: { sdk: ^3.5.0 }
dependencies:
  kiwi: { path: /Users/usuario/projects/my/kiwi/packages/kiwi }
dev_dependencies:
  build_runner: any
  json_serializable: any
  kiwi_generator: { path: /Users/usuario/projects/my/kiwi/packages/kiwi_generator }
```

```bash
dart pub get     # ← must succeed. This is the whole point of Phase 1.
```

### Step 1.7 — Version, changelog, publish (1 h)

- `packages/kiwi_generator/pubspec.yaml` → `version: 5.0.0`
- `packages/kiwi_generator/CHANGELOG.md` → top line **exactly** `# 5.0.0`
  (`tools/kiwi_cli_actions` asserts this literal match and fails CI otherwise).
  Content: the SDK floor bump, the dependency bumps, and "fixes resolution
  conflicts with modern build_runner packages."
- `dart pub publish --dry-run`, then publish.

### Step 1.8 — Close the loop with users (20 min, do not skip)

The cheapest goodwill on the entire list:

- **#91** "It is not generating anything" — you told them in Jan 2024 to wait for
  a release tag. Post the 5.0.0 link and ask them to retry.
- **PR #127** assisted-injection PoC — open and unanswered since Mar 2025.
  Even "thanks, this is interesting, here's what I'd need to merge it" beats
  eighteen months of silence.
- **PR #126** dart_style 3.0.1 — close it as superseded, referencing 5.0.0.
- **PR #128** flutter-action bump — merge.

## Phase 1 definition of done — 3 criteria, nothing else

1. `dart test` green in `packages/kiwi_generator` (10 existing + the new
   nullable golden test).
2. Step 1.6 `dart pub get` succeeds with `json_serializable` present and zero
   `dependency_overrides`.
3. Both examples regenerate byte-identical `.g.dart`.

When those three pass, **ship it.** Do not add anything from Phase 2 or 3 to
that PR.

---

# Phase 2 — make CI able to catch this (~1 day)

Phase 1 fixes today's breakage. Phase 2 is what stops it recurring. Nothing here
is user-visible, so it does not belong in the 5.0.0 release.

**Branch:** `ci/close-verification-gaps`

### Step 2.1 — The no-overrides resolution job (the important one)

New workflow, or a job in `build_all.yml`. Scripted version of Step 1.6: build a
throwaway app in `$RUNNER_TEMP` depending on both packages by path, plus
`json_serializable` and `build_runner` at `any`, with **no**
`dependency_overrides`, and run `dart pub get`.

This is the single check that would have caught the 19-month rot. Every existing
workflow was green the entire time the published package was un-installable,
because the examples' `dependency_overrides` mask exactly this.

### Step 2.2 — Fix the dead codegen-drift gate

`.github/workflows/build_all.yml`, both the `flutter` and `dart` jobs:

```yaml
- name: Verify generated files are up to date
  id: verify-changed-files          # ← this is missing today
  uses: tj-actions/verify-changed-files@v20

- name: Fail if generated output drifted
  if: steps.verify-changed-files.outputs.files_changed == 'true'
  run: |
    echo "Changed: ${{ steps.verify-changed-files.outputs.changed_files }}"
    exit 1                          # ← today it only echoes
```

Without the `id:`, that `if:` has always evaluated false. The gate has never
fired once.

### Step 2.3 — Make `tools/*.sh` work

```bash
git update-index --chmod=+x tools/*.sh
```

They are all committed non-executable, so `./tools/all.sh` dies with "Permission
denied". Also add the cd-guard that `test.sh` and `analyze.sh` already have to
`all.sh`, which calls `./packages_get.sh` relative to cwd and therefore only
works from inside `tools/`.

### Step 2.4 — Adopt `package:lints`

Both `analysis_options.yaml` files currently list 6 hand-picked rules.

```yaml
include: package:lints/recommended.yaml
```

`implementation_imports` alone would have caught the `package:build/src/...`
import from Step 1.1. Expect a cleanup commit; keep it separate from the rule
change so the diff is reviewable.

### Step 2.5 — Housekeeping

- Delete `packages/*/mono_pkg.yaml` — dead `mono_repo` config invoking `dartfmt`
  and `dartanalyzer`, both removed from the SDK. Nothing reads them.
- Add coverage: `dart test --coverage` + a Codecov badge. You have 25 + 10 tests
  and no idea what they cover.
- Extend `dependabot.yml` to `/examples/*` and `/tools/kiwi_cli_actions`
  (root `github-actions` and both packages are already covered).

---

# Phase 3 — docs and community health (~2 days)

Do this after 5.0.0 is out, when the traffic from the release arrives.

### Step 3.1 — Fix what's actively wrong in the READMEs

- `packages/kiwi/README.md:12` — **"IMPORTANT: Dart2 is required to use this
  package."** Delete.
- `packages/kiwi/README.md:4` — the Donate badge points at
  **paypal.me/RomainRastel**, the original author. Your call whether to remove it
  or repoint it, but shipping it unchanged is odd.
- `packages/kiwi/README.md:196` — *"you will get `null` if you try to resolve a
  type that was not previously registered"*. **Not true.**
  `kiwi_container.dart:162-165` throws unconditionally, `silent` or not, and
  `T resolve<T>()` returns non-nullable `T`. Fix the docs now; the API question
  is a 6.0.0 discussion (see below).

### Step 3.2 — Answer issue #118

*"Please add docs which example is compile-time DI"* — open since Jun 2024, you
promised docs. pub.dev advertises kiwi as "compile-time dependency injection"
and nothing explains what that means. A "Runtime vs. compile-time registration"
section with two side-by-side snippets closes it.

### Step 3.3 — Add the comparison table

The first question every Flutter dev asks is "why not `get_it` + `injectable`?"
Answer it in the root README honestly: kiwi is smaller, zero-dependency, no
async registration, no disposal hooks. Being upfront about what you *don't* do
converts better than pretending.

### Step 3.4 — Community health files

All confirmed missing: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`,
issue templates, PR template. With 348 stars and 58 forks this is overdue —
templates alone will improve the signal quality of incoming issues.

### Step 3.5 — Low-risk core cleanup (non-breaking, `kiwi` 5.1.0)

- The same ~5-line error string is duplicated **four times** across `resolve`,
  `unregister` and `resolveAs`. Extract one private builder.
- `_Provider.get`: a singleton whose builder returns `null` sets `_oneTime =
  false` and then re-invokes the builder on every resolve — it silently stops
  being a singleton. Add a test, then fix.
- Add the missing `silent = true` tests. The existing "Silent=true" group only
  covers happy paths, which is why the README's claim went unchallenged for years.

---

# Later — 6.0.0 decisions, not scheduled

Breaking changes to `kiwi` core. These need a design discussion, not a ticket.
Listed so they don't get rediscovered every six months.

- **`providers` getter returns the live internal map** (`kiwi_container.dart:51`).
  Callers can mutate container internals. Return an unmodifiable view.
- **`resolveOrNull<T>()`** — the honest fix for the `silent` contradiction.
  `resolve<T>()` returning non-nullable `T` cannot express "not found."
- **`resolveAs` is `@visibleForTesting` yet is public API.** Pick one.
- **Disposal hooks** — `unregister` / `clear` drop instances with no chance to
  clean up. The most commonly requested feature in DI containers.
- **Assisted injection** — PR #127. Reply first (Step 1.8), decide later.

---

# What I'd tell you if you asked for one sentence

Phase 1 is worth more than Phases 2 and 3 combined, because right now anyone who
tries kiwi in 2026 gets a version-solve error and installs `get_it` instead.
Everything below Phase 1 can wait; that cannot.
