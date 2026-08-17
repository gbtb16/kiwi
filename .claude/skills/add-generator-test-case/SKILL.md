---
name: add-generator-test-case
description: Use when adding, changing, or debugging a kiwi_generator test case — any work that touches packages/kiwi_generator/test/. The expected output is a hand-written golden string that must match DartFormatter byte-for-byte, so guessing the whitespace fails; this covers the input file shape, the raw-string requirement, and how to obtain the exact expected output instead of guessing it.
---

# Adding a kiwi_generator test case

Three files move together: an input under `test/inputs/`, a `const` golden string
in `kiwi_generator_test.dart`, and a `testKiwi` call referencing both.

**Run everything from `packages/kiwi_generator/`.** `test_helper.dart` builds the
path as `./test/inputs/<name>.dart`, relative to the process CWD — from anywhere
else every test fails with "Its not possible to find inputs file."

## 1. Write the input file

`test/inputs/<case_name>.dart`. One abstract class carrying the annotations, plus
the service classes it references, all in the same file — `resolveSources` only
resolves this one file plus its package imports.

```dart
import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(Service, from: ServiceB, name: 'factoryB')
  void configure();
}

class Service {
  const Service();
}

class ServiceA extends Service {
  const ServiceA();
}
```

The generator only fires on an abstract class with **at least one abstract method
annotated with `@Register`**. Drop the annotation, or give the method a body, and
`generate()` returns `null` — that is a valid case to test, and the expected
value is the literal `null`, not `''`.

## 2. Get the expected output — do not type it by hand

The golden string must equal `DartFormatter`'s output exactly, including where it
wraps long lines and how it indents the wrapped continuation. Writing it from
memory is the main way this task fails.

Add the `testKiwi` call with `null` as the expected value first, then run the
single test and copy the `Actual:` block from the failure:

```bash
cd packages/kiwi_generator
dart test test/kiwi_generator_test.dart -n 'name of the new test'
```

`test_helper.dart` calls `expect(actual, output)` — actual first — so the
failure prints your generated source under `Actual:` and `null` under
`Expected:`. That `Actual:` text *is* the golden string.

The failure also prints **"Its not possible to find inputs file."** — ignore it.
`testKiwi` wraps its whole body in one `catch` that prints that line for *any*
error, including a plain assertion mismatch. It does not mean the input file is
missing. Read the `Actual:`/`Expected:` blocks below it instead.

Reconstruct the string from the `\n`-delimited fragments — the reporter prints
one quoted fragment per line. Do not trust your intuition about the layout:
`code_builder` emits the whole cascade, and `DartFormatter` keeps a single-entry
cascade on one line (`container..registerFactory<Service>((c) => ServiceB.other());`)
while splitting a multi-entry one across indented `..` lines.

## 3. Add the golden string

It must be a **raw** triple-quoted string. The generated class is named
`_$Injector`; in a non-raw string `$Injector` is read as interpolation and the
test file stops compiling.

```dart
const _outputMyCase = r'''
class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container..registerFactory((c) => ServiceA());
  }
}
''';
```

Note the shape: a newline directly after `r'''`, and a trailing newline before
the closing `'''` — `generate()` returns formatter output, which ends with one.
It returns only the emitted class, with no `part` directive or ignore header.

## 4. Wire up the test

Add to the group that matches the annotation under test (`Register.factory`,
`Register.singleton`, or `Generates null`):

```dart
test('my case', () async {
  await testKiwi('my_case', _outputMyCase);
});
```

For a case that must throw, use `testKiwiException`. `KiwiGeneratorError`'s
`toString()` wraps the message in blank lines, so the matcher looks like:

```dart
await testKiwiException(
  'my_error_case',
  const TypeMatcher<KiwiGeneratorError>().having(
    (f) => f.toString(),
    'toString()',
    '\nKiwiGeneratorError\n\nthe constructor Service.unknown does not exist\n\n',
  ),
);
```

## 5. Verify

```bash
cd packages/kiwi_generator
dart test
dart format -o none --set-exit-if-changed .
dart analyze --fatal-warnings .
```

CI runs `dart format` with `--set-exit-if-changed`, and the new input file counts.
Note that formatting the *test input* is separate from the golden string's
content — the golden string is data inside a raw literal, and the formatter will
not reindent it for you.
