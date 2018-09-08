# kiwi

![Logo](./images/logo_220x160.png)

 A simple compile-time dependency injection library for Dart and Flutter, that does not rely on reflection.
Only constructor injection is supported.

**IMPORTANT: Dart2 is required to use this package.**

## Getting Started

This package can be used with, or without code generation. While code generation allows you to code faster, it comes with extra configuration on you side (to be setup only one time).

### Configuration

Add `kiwi` to `pubspec.yaml` under the `dependencies` field.

```yaml
dependencies:
  kiwi: ^0.1.0
```

#### With code generation

1. Add [build_runner](https://github.com/dart-lang/build/tree/master/build_runner) and `kiwi_generator` under the `dev_dependencies` field of the `pubspec.yaml`. file

```yaml
dev_dependencies:  
  build_runner: 0.10.1+1
  kiwi_generator: ^0.1.0
```

2. Add (or modify) the `build.yaml` file in the same folder as the `pubspec.yaml` and include the `kiwi` builder.

```yaml
targets:
  $default:
    builders:
      kiwi:
```

### Import

In your library add the following import:

```dart
import 'package:kiwi/kiwi.dart';
```

### Usage

The core of kiwi is the `Container` class. This is where all your instances and factories are stored.
The `Container` is implemented as a singleton, you can access the single instance like this:

```dart
Container container = Container();
```

**Note:** I promise you, even if this is looking like a constructor, you will always end up with the same instance.

You can register 3 kinds of objects:

#### Instances

Kiwi can register simple instances like that:

```dart
container.registerInstance(Sith('Anakin', 'Skywalker'));
```

You can also give a name to a specific instance:

```dart
container.registerInstance(Sith('Anakin', 'Skywalker'), name: 'DartVader');
```

By default instances are registered under their type. If you want to register an instance under a supertype, you have to specify both of them:

```dart
container.registerInstance<Character, Sith>(Sith('Anakin', 'Skywalker'), name: 'DartVader');
```

In the above example `Person` is a supertype of `Sith`.

#### Factories

#### Singletons