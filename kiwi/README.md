# kiwi

![Logo](../images/logo_220x160.png)

A simple yet efficient IoC container for Dart and Flutter, coupled with a powerful generator to allow you to write less code.

The container does not rely on reflection, it's just a bunch of `Map` so it's fast.

A simple compile-time dependency injection library for Dart and Flutter, that does not rely on reflection.
Only constructor injection is supported.

**IMPORTANT: Dart2 is required to use this package.**

This package can be used with, or without code generation. While code generation allows you to code faster, it comes with extra configuration on you side (to be setup only one time).
This section is only about **kiwi** which contains the IoC container and the annotations. For the kiwi_generator configuration, it's here.

## Configuration

Add `kiwi` to `pubspec.yaml` under the `dependencies` field.

```yaml
dependencies:
  kiwi: ^0.1.0
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

It works like a lot of IoC containers: you can register a factory under a type, and then resolve the type to get a value.

### Registering

You can register 3 kinds of objects:

1. Instances

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