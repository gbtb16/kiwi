# kiwi

[![kiwi](https://github.com/gbtb16/kiwi/actions/workflows/kiwi.yml/badge.svg?branch=master)](https://github.com/gbtb16/kiwi/actions/workflows/kiwi.yml)
[![kiwi_generator](https://github.com/gbtb16/kiwi/actions/workflows/kiwi_generator.yml/badge.svg?branch=master)](https://github.com/gbtb16/kiwi/actions/workflows/kiwi_generator.yml)
[![dart_kiwi_example](https://github.com/gbtb16/kiwi/actions/workflows/dart_kiwi_example.yml/badge.svg?branch=master)](https://github.com/gbtb16/kiwi/actions/workflows/dart_kiwi_example.yml)
[![flutter_kiwi_example](https://github.com/gbtb16/kiwi/actions/workflows/flutter_kiwi_example.yml/badge.svg?branch=master)](https://github.com/gbtb16/kiwi/actions/workflows/flutter_kiwi_example.yml)

![Logo](https://raw.githubusercontent.com/gbtb16/kiwi/master/images/logo.png)

A simple yet efficient IoC container for Dart and Flutter, coupled with a powerful generator to allow you to write less code.

The container does not rely on reflection, it's just a `Map`, so it's fast.

While using the generator, only constructor injection is supported.

## Kiwi

[![Pub](https://img.shields.io/pub/v/kiwi.svg)](https://pub.dartlang.org/packages/kiwi)

[Source Code](https://github.com/gbtb16/kiwi/tree/master/packages/kiwi)

The core package providing the IoC container and the annotations which has no dependencies.

Import it into your pubspec `dependencies:` section.

## Kiwi Generator

[![Pub](https://img.shields.io/pub/v/kiwi_generator.svg)](https://pub.dartlang.org/packages/kiwi_generator)

[Source Code](https://github.com/gbtb16/kiwi/tree/master/packages/kiwi_generator)

The package providing the generator.

Import it into your pubspec `dev_dependencies:` section.

## Dart Kiwi Example

[Source Code](https://github.com/gbtb16/kiwi/tree/master/examples/dart_kiwi)

An example showing how to setup `kiwi` and `kiwi_generator` inside a Dart CLI project.

## Flutter Kiwi Example

[Source Code](https://github.com/gbtb16/kiwi/tree/master/examples/flutter_kiwi)

An example showing how to setup `kiwi` and `kiwi_generator` inside a Flutter project.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/gbtb16/kiwi/issues).  
If you fixed a bug or implemented a new feature, please send a [pull request](https://github.com/gbtb16/kiwi/pulls).