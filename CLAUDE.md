# CLAUDE.md

Guidance for Claude Code (claude.com/claude-code) and other AI agents working in
this repository.

## What this is

`kiwi` is a reflection-free IoC / dependency-injection container for Dart and
Flutter, plus an optional `build_runner` code generator. Published on pub.dev.
Public OSS with external contributors — treat every change as user-facing.

Monorepo, but no orchestrator is actually in use. Each package resolves
independently.

```
packages/kiwi/            # the container + annotations. Only dep: meta.
packages/kiwi_generator/  # build_runner generator. Depends on kiwi.
examples/dart_kiwi/       # CLI example (uses dependency_overrides)
examples/flutter_kiwi/    # Flutter example (uses dependency_overrides)
tools/kiwi_cli_actions/   # CI helper that validates CHANGELOG entries
tools/*.sh                # convenience scripts — see the gotcha below
```

`packages/*/mono_pkg.yaml` are **stale**. They configure dart-lang `mono_repo`
with `dartfmt` / `dartanalyzer`, both removed from the Dart SDK, and nothing
consumes them — CI is hand-written GitHub Actions. Ignore them; don't extend them.

## Commands

Run per package — there is no workspace-wide `pub get`.

```bash
cd packages/kiwi           && dart pub get && dart analyze --fatal-warnings . && dart test
cd packages/kiwi_generator && dart pub get && dart analyze --fatal-warnings . && dart test
cd packages/kiwi_generator && dart run build_runner build --delete-conflicting-outputs
```

The `tools/*.sh` helpers are checked in **without the executable bit**, so
`./tools/all.sh` fails with "Permission denied" — and `all.sh` invokes its
siblings as `./packages_get.sh`, so it only resolves from inside `tools/` anyway.
Until that is fixed, run them as `cd tools && bash analyze.sh` (one at a time),
or just use the per-package commands above.

CI additionally enforces `dart format -o none --set-exit-if-changed .`, so
always format before committing. Both packages are tested on the `stable`,
`beta`, and `dev` SDK channels.

## Architecture

**`packages/kiwi/lib/src/kiwi_container.dart`** is the whole container, ~270
lines. Storage is `Map<String?, Map<Type, _Provider<Object>>>` — outer key is the
optional registration name (`null` for unnamed), inner key is the type.

- `KiwiContainer()` is a factory returning a process-wide singleton.
- `KiwiContainer.scoped({parent})` copies the parent's inner maps at construction
  time (`Map.from`), so later parent registrations do **not** propagate. The
  `_Provider` objects themselves are *shared*, so a singleton already cached in
  the parent yields the same instance in the child. This is deliberate; see the
  comment at the constructor.
- `_Provider` has three shapes: instance, factory (rebuilds every resolve), and
  singleton (`_oneTime` — builds once, then caches).
- `silent` suppresses duplicate-registration and not-registered errors.

**`packages/kiwi_generator/lib/src/kiwi_injector_generator.dart`** is a
`source_gen` `Generator`. It finds abstract classes whose abstract methods carry
a `@Register.factory` / `@Register.singleton` annotation, and emits a `_$Name`
subclass that cascades `registerFactory` / `registerSingleton` calls onto a
`KiwiContainer`. Constructor injection only.

Generator tests are golden-file based: `test/inputs/*.dart` are the sources,
`test/utils/test_helper.dart` compares generated output. Add a new input file
plus a test case when changing generator behaviour.

## Conventions

- **English everywhere** — code, comments, docs, commits, issue and PR replies.
- Commit messages: `type(scope): description.` — e.g.
  `fix(kiwi-generator): upgrade analyzer dependency.` Common types seen in
  history: `fix`, `chore`, `build(deps)`, `feat`.
- Every change to a package **must** add a CHANGELOG entry. The `changelog`
  workflow (`tools/kiwi_cli_actions`) fails the build otherwise, and it also
  checks that the CHANGELOG top version matches `pubspec.yaml`.
- Analysis is configured per package in `analysis_options.yaml`. It is currently
  a short hand-picked rule list, not `package:lints`.

## Gotchas

- **The examples use `dependency_overrides` pointing at local paths.** This means
  CI never exercises real pub resolution, and cannot catch the case where a
  published `kiwi_generator` fails to resolve against a user's other codegen
  packages. When touching generator dependency constraints, verify resolution in
  a scratch project *without* overrides.
- `kiwi_generator` currently pins an old build stack (`analyzer ^6`,
  `source_gen >=1.5.0 <3.0.0`, `build ^2.4.1`, `dart_style ^2.2.4`). Bumping
  these is a breaking migration — the analyzer element model, `TypeChecker`
  construction, `getDisplayString(withNullability:)`, and the `DartFormatter`
  constructor all changed.
- `resolve<T>()` returns non-nullable `T` and throws on a missing registration
  **even when `silent` is true**. The README claims it returns `null`. The docs
  are wrong, not the code — don't "fix" the code without a deliberate API decision.
- `packages/kiwi/lib/src/kiwi_container.dart` exposes `providers` as the live
  internal map, not a copy. Changing that is a breaking change.
- Version bumps must stay consistent across `packages/kiwi_generator/pubspec.yaml`
  (its `kiwi:` constraint) and both example pubspecs.

## Before opening a PR

1. Both packages: `dart pub get`, `dart analyze --fatal-warnings .`, `dart test`,
   and `dart format -o none --set-exit-if-changed .` all pass.
2. CHANGELOG updated for every package you touched — the top line must be
   exactly `# <version from pubspec.yaml>`, which is what
   `tools/kiwi_cli_actions` asserts.
3. If generator output changed, both examples' `.g.dart` files are regenerated
   and committed.
