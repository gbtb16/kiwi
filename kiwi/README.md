# kiwi

[![Pub](https://img.shields.io/pub/v/kiwi.svg)](https://pub.dartlang.org/packages/kiwi)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/RomainRastel)

![Logo](https://raw.githubusercontent.com/letsar/kiwi/master/images/logo.png)

A simple yet efficient IoC container for Dart and Flutter.

The container does not rely on reflection, it's just a `Map`, so it's fast.

**IMPORTANT: Dart2 is required to use this package.**

This package can be used with, or without code generation. While code generation allows you to code faster, it comes with extra configuration on you side (to be setup only one time).
This section is only about **kiwi** which contains the IoC container and the annotations. If you are looking for the kiwi_generator configuration, you can find documentation [here](https://github.com/letsar/kiwi/tree/master/kiwi_generator).

## Configuration

Add `kiwi` to `pubspec.yaml` under the `dependencies` field.
The latest version is [![Pub](https://img.shields.io/pub/v/kiwi.svg)](https://pub.dartlang.org/packages/kiwi)

```yaml
dependencies:
  kiwi: ^latest_version
```

## Import

In your library add the following import:

```dart
import 'package:kiwi/kiwi.dart';
```

## Usage

The core of **kiwi** is the `Container` class. This is where all your instances and factories are stored.
The `Container` is implemented as a singleton, you can access the single instance like this:

```dart
Container container = Container();
```

**Note:** I promise you, even if this is looking like a constructor, you will always end up with the same instance :wink:.

If you want different containers, you can create scoped ones easily:

```dart
Container container = Container.scoped();
```

**Important: If you want to use the `Container` class with Flutter code, you have to specify a library prefix:**

```dart
import 'package:kiwi/kiwi.dart' as kiwi;
...
kiwi.Container container = kiwi.Container();
```

It works like a lot of IoC containers: you can register a factory under a type, and then resolve the type to get a value.

### Registering

You can register 3 kinds of objects:

#### Instances

**Kiwi** can register simple instances like that:

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

In the above example `Character` is a supertype of `Sith`.

#### Factories

```dart
container.registerFactory((c) => Sith('Anakin', 'Skywalker'));
```

You can also give a name to a specific factory:

```dart
container.registerFactory((c) => Sith('Anakin', 'Skywalker'), name: 'DartVader');
```

By default factories are registered under the return type of the factory. If you want to register an factory under a supertype, you have to specify both of them:

```dart
container.registerFactory<Character, Sith>((c) => Sith('Anakin', 'Skywalker'), name: 'DartVader');
```

**Note:** the `c` parameter is the instance of the `Container`, we will saw later how it can be useful.

#### Singletons

Singletons are registered like factories but they are called only once: the first time we get their value.

```dart
container.registerSingleton((c) => Sith('Anakin', 'Skywalker'));
```

### Resolving

You can get the instance registered for a type like this:

```dart
Sith theSith = container.resolve<Sith>();
```

If it was registered under a name, you can get its value like this:

```dart
Sith theSith = container.resolve<Sith>('DartVader');
```

The `Container` is a callable class. You can also resolve a type like that:

```dart
Sith theSith = container<Sith>('DartVader');
```

## Usage with dependencies

If you have a service that depends on another, you have to add the dependency in the constructor. For registering the service, you can then use the `c` parameter we saw earlier to resolve the value.

```dart
class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {
  ServiceB(ServiceA serviceA);
}
...
// Registers a complex factory by resolving the dependency
// when the type is resolved.
Container container = Container();
container.registerFactory((c) => ServiceB(c.resolve<ServiceA>()));
```

For services with a lot of dependencies, it can be tedious to write that sort of code. That's why **kiwi** comes with a generator :smiley:!

## Unregistering

You can unregister a factory/instance at any time:

```dart
// Unregisters the Sith type.
container.unregister<Sith>();

// Unregister the Sith type that was registered under the name DartVader.
container.unregister<Sith>('DartVader');
```

## Cleaning

You can remove all the registered types by calling the `clear` method:

```dart
container.clear();
```

## Ignoring assertion errors in development mode

By default **kiwi** throws an `AssertionError` in the following cases:

* if you register the same type under the same name a second time.
* if you try to resolve or unregister a type that was not previously registered.

This helps you to prevent potential errors in production, however you might want to ignore these assertion errors. To do this you can set `true` to the `silent` property of the `Container`:

```dart
container.silent = true;
```

In production, or when `silent` is `true`, you will get `null` if you try to resolve a type that was not previously registered.

## Changelog

Please see the [Changelog](https://github.com/letsar/kiwi/blob/master/kiwi/CHANGELOG.md) page to know what's recently changed.