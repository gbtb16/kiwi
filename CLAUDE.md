# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

Multi-package Dart/Flutter monorepo with **no** workspace tool (no melos, no pub workspaces). Each package has its own `pubspec.yaml` and must be operated on from its own directory.

- `packages/kiwi` — the runtime IoC container + `@Register` annotations. Zero deps except `meta`. Published to pub.
- `packages/kiwi_generator` — `source_gen` builder that emits container registration code from annotations. Depends on `kiwi` from pub (`^5.0.1`), **not** via a path override. Requires Dart `^3.9.0`.
- `examples/dart_kiwi`, `examples/flutter_kiwi` — consumer examples; their generated `*.g.dart` files are committed and CI fails if regeneration changes them.
- `tools/*.sh` — bash helpers that loop the same command over all four packages.
- `tools/kiwi_cli_actions` — small Dart CLI used by CI to assert `CHANGELOG.md` starts with `# <pubspec version>`.

## Commands

Repo-wide helpers — **currently broken, prefer the per-package commands below.**
`tools/*.sh` are all committed without the executable bit, so `./tools/all.sh`
fails with "Permission denied". Invoke them through `bash` instead. Most of them
self-locate (a `basename == 'tools'` cd-up guard), but `all.sh` does **not** — it
calls `./packages_get.sh` relative to cwd, so it only resolves from inside
`tools/`, and fails there anyway because its siblings aren't executable.

```bash
cd tools && bash packages_get.sh   # pub get in all packages
cd tools && bash analyze.sh        # dart/flutter analyze in all packages (--fatal-infos)
cd tools && bash format.sh         # dart format .
cd tools && bash test.sh           # dart test for kiwi + kiwi_generator (examples have no tests)
cd tools && bash build.sh          # build_runner in kiwi_generator + both examples
```

Per-package (what CI actually runs):

```bash
cd packages/kiwi            # or packages/kiwi_generator
dart pub get
dart analyze --fatal-warnings .
dart format -o none --set-exit-if-changed .
dart test
dart test test/kiwi_test.dart -n 'name of the test'   # single test / group
```

Examples use Flutter tooling even for `dart_kiwi`: `flutter packages get && flutter analyze`.

Regenerating code (required after touching the generator or example annotations):

```bash
cd packages/kiwi_generator && dart run build_runner build
cd examples/dart_kiwi       && dart run build_runner build
cd examples/flutter_kiwi    && dart run build_runner build
```

`build_runner` removed `--delete-conflicting-outputs`; passing it now aborts the
build. Conflicting outputs are overwritten automatically.

## Architecture

**Runtime (`packages/kiwi`)** — `KiwiContainer` is a two-level map: `Map<String? name, Map<Type, _Provider>>`. No reflection. `KiwiContainer.scoped({parent})` copies the parent's inner maps (`Map.from`) so later parent registrations don't leak into the child scope — but the `_Provider` objects themselves are **shared**, so a singleton already built in the parent hands back the *same instance* in the child. Resolution failures throw `NotRegisteredError` (subclass of `KiwiError`). Public surface is re-exported from `lib/kiwi.dart`; everything else lives under `lib/src/`.

**Annotations** — `Register.factory(...)` and `Register.singleton(...)` differ only in the private `oneTime` flag. Options: `from` (concrete impl for an abstract `type`), `name` (named registration), `resolvers` (`Map<Type, String>` telling the generator which *named* dependency to resolve per constructor param type), `constructorName` (named constructors).

**Generator (`packages/kiwi_generator`)** — `KiwiInjectorGenerator extends Generator` (a `SharedPartBuilder`, output `.kiwi.g.part`, `auto_apply: dependents`, `build_to: cache`, declared in `build.yaml` under the key `kiwi_generator|kiwi` — a package may only declare builders under its own name). It scans a library for **abstract classes with at least one abstract method annotated with `@Register`** and emits `class _$Injector extends Injector` using `code_builder` + `DartFormatter`. Only constructor injection is supported. Abstract register methods accept at most one parameter, which must be a `KiwiContainer scopedContainer`. All unexpected `Error`s are wrapped in `KiwiGeneratorError` pointing users at the issue tracker; `KiwiGeneratorError` and `UnresolvedAnnotationException` pass through.

`packages/kiwi_generator/build.yaml` restricts generation to `example/kiwi_generator_example.dart` for the package's own build — the real coverage is in tests, not that build.

## Generator tests

Golden-string tests, not snapshot files. `test/inputs/<case>.dart` holds the annotated input; `kiwi_generator_test.dart` holds the expected generated source as a `const` string; `testKiwi('<case>', expected)` runs the generator over the resolved library via `resolveSources` (`test/utils/analysis.dart`) and compares strings. Error cases use `testKiwiException('<case>', matcher)`.

Adding a generator feature means: new file in `test/inputs/`, new expected-output string, new `testKiwi` call. Expected output must match `DartFormatter` output exactly (whitespace included) — `generate()` returns only the emitted classes, without any part/ignore header.

`resolveCompilationUnit` passes `readAllSourcesFromFilesystem: true`. Without it
`package:kiwi` is unreadable, every `@Register` annotation resolves to `null`,
and source_gen throws `UnresolvedAnnotationException`. Do not remove it.

`generate()` formats with `DartFormatter.latestShortStyleLanguageVersion`, so the
golden strings are in **short** style. Real builds look different: source_gen
reformats the combined file at the *consumer's* language version, which is tall
style for anything past 3.7. No test covers that output.

## Release / CI constraints

- Bumping a package's `version` in `pubspec.yaml` **requires** the `CHANGELOG.md` to begin with `# <that version>` — the `changelog` workflow exits 1 otherwise.
- `build_all` regenerates code in the generator and both examples. It *intends* to fail when tracked files change, but the gate is **dead**: the `verify-changed-files` step has no `id:`, so the `if:` that reads its output is always false, and the guarded step only `echo`s. Commit regenerated output anyway — nothing is checking for you.
- `kiwi` and `kiwi_generator` are tested against `stable`, `beta` and `dev` Dart SDKs. They have **different** SDK floors: `kiwi` is still `>=2.14.0 <4.0.0`, while `kiwi_generator` requires `^3.9.0` (forced by `analyzer`, `source_gen` and `dart_style`). That difference is also why `dart format` uses short style in `kiwi` and tall style in `kiwi_generator` and the examples — do not "unify" the formatting.
- Local `tools/analyze.sh` uses `--fatal-infos` (stricter than CI's `--fatal-warnings`).

## Gotchas

- **The examples use `dependency_overrides` pointing at local paths**, so CI never exercises real pub resolution and cannot catch a published `kiwi_generator` that fails to resolve against a user's other codegen packages. When touching generator dependency constraints, verify in a scratch project *without* overrides.
- `analyzer` is constrained to `^10.0.0`, deliberately **not** `^10.2.0`: 10.2.0 requires `meta ^1.18.0`, which conflicts with the `meta 1.16.0` pinned by Flutter 3.35. The caret lets pub pick 10.0.1 on older Flutter and 10.2.x on newer. Do not tighten it without checking against a real Flutter SDK.
- The generator emits `c.resolve<T>()` with nullability stripped **recursively** (`List<ServiceA?>` -> `List<ServiceA>`), via the `_typeName` helper. `KiwiContainer` keys providers by exact `Type`, so emitting the nullable form resolves a different key and throws at runtime.
- `resolve<T>()` returns non-nullable `T` and throws on a missing registration **even when `silent` is true** (`kiwi_container.dart:162`). `packages/kiwi/README.md` claims it returns `null`. The docs are wrong, not the code — don't "fix" the code without a deliberate API decision.
- `KiwiContainer.providers` returns the **live** internal map, not a copy. Changing that is breaking.
- `packages/*/mono_pkg.yaml` are stale dart-lang `mono_repo` configs invoking `dartfmt`/`dartanalyzer` (both removed from the SDK). Nothing reads them; don't extend them.
- Version bumps must stay consistent across `packages/kiwi_generator/pubspec.yaml` (its `kiwi:` constraint) and both example pubspecs.
