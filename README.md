# kiwi

![Logo](https://raw.githubusercontent.com/letsar/kiwi/master/images/logo_220x160.png)

A simple yet efficient IoC container for Dart and Flutter, coupled with a powerful generator to allow you to write less code.

The container does not rely on reflection, it's just a `Map`, so it's fast.

While using the generator, only constructor injection is supported.

**IMPORTANT: Dart2 is required to use this package.**

## Container and annotations

[![Pub](https://img.shields.io/pub/v/kiwi.svg)](https://pub.dartlang.org/packages/kiwi)

[Source Code](https://github.com/letsar/kiwi/tree/master/kiwi)

The core package providing the IoC container and the annotations which has no dependencies.

Import it into your pubspec `dependencies:` section.

## Generator

[![Pub](https://img.shields.io/pub/v/kiwi_generator.svg)](https://pub.dartlang.org/packages/kiwi_generator)

[Source Code](https://github.com/letsar/kiwi/tree/master/kiwi_generator)

The package providing the generator.

Import it into your pubspec `dev_dependencies:` section.

## Example

[Source Code](https://github.com/letsar/kiwi/tree/master/example)

An example showing how to setup `kiwi` and `kiwi_generator`.

## Flutter Example

[Source Code](https://github.com/letsar/kiwi/tree/master/flutter_example)

An example showing how to setup `kiwi` and `kiwi_generator` inside a Flutter project.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/letsar/kiwi/issues).  
If you fixed a bug or implemented a new feature, please send a [pull request](https://github.com/letsar/kiwi/pulls).