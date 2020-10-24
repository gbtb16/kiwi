# kiwi_generator

[![Pub](https://img.shields.io/pub/v/kiwi_generator.svg)](https://pub.dartlang.org/packages/kiwi_generator)

![Logo](https://raw.githubusercontent.com/vanlooverenkoen/kiwi/master/images/logo.png)

Generates dependency injection code using the [kiwi](https://github.com/vanlooverenkoen/kiwi) package to reduce development time.

## Configuration

1. Add `kiwi` to `pubspec.yaml` under the `dependencies:` section.
The latest version is [![Pub](https://img.shields.io/pub/v/kiwi.svg)](https://pub.dartlang.org/packages/kiwi)

```yaml
dependencies:
  kiwi: ^latest_version
```

2. Add [build_runner](https://github.com/dart-lang/build/tree/master/build_runner) and `kiwi_generator` under the `dev_dependencies:` section of the `pubspec.yaml` file.
The latest version is [![Pub](https://img.shields.io/pub/v/kiwi_generator.svg)](https://pub.dartlang.org/packages/kiwi_generator)

```yaml
dev_dependencies:  
  build_runner: ^1.10.0
  kiwi_generator: ^latest_version
```

3. Add (or modify) the `build.yaml` file in the same folder as the `pubspec.yaml` and include the `kiwi` builder.

```yaml
targets:
  $default:
    builders:
      kiwi:
```

## Usage

In your library add the following import:

```dart
import 'package:kiwi/kiwi.dart';
```

Create an abstract class with an abstract method:

```dart
abstract class Injector {
  void configure();
}
```

Annotate the abstract method with the **kiwi** `Register` annotations.

```dart
abstract class Injector {  
  @Register.singleton(ServiceA)
  @Register.factory(Service, from: ServiceB)
  @Register.factory(ServiceB, name: 'factoryB')
  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  void configure();
}
```

Include the part directive indicating the file that will be generated (typically the same file with a `.g` extension before `.dart`):

```dart
part 'test01.g.dart';
```

Run build_runner:

```bash
pub run build_runner build
```

For Flutter the command is different though:

```bash
flutter packages pub run build_runner build
```

**Note:** On first attempt to run this command you might encounter a conflict error. If so, please add the --delete-conflicting-outputs argument to your command:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```
(This additional argument allows the command to overwrite the `.g.dart` file if necessary.)

You can also use the `watch` command instead of `build`. This will generate your file when it's saved.

```bash
pub run build_runner watch
```

A concrete class named `_$TheNameOfYourAbstractClass` will be generated and you can call the method where you like.
For example you can create a function in your library which will call it:

```dart
void setup() {
  var injector = _$Injector();
  injector.configure();
}
```

Or you can create a function that will return the concrecte injector and use it elsewhere:

```dart
Injector getInjector() => _$Injector();
```

## Annotations

There is only one annotation, called `Register`, with two constructors: `factory` and `singleton`. There are no constructor for registering instances because only `const` instances are supported in metadata. And it would'nt be easier to create an annotation than registering directly with a container.

If you want to register a singleton (the factory will be called only one time, when accessing it for the first time):

```dart
@Register.singleton(ServiceA)
```

If you want to register a factory:

```dart
@Register.factory(ServiceA)
```

Both constructors have the same parameters:

**Parameter**|**Type**|**Required**|**Description**
-----|:-----:|:-----:|-----
`type`|Type|Yes|This is the type to register
`name`|String|No|This is the name under which the factory will be registered
`from`|Type|No|The type to create when requesting `type`, if different of `type`.
`constructorName`|String|No|The name of the constructor to use inside the factory
`resolvers`|Map<String, String>|No|A map that give for a type, the name under which it should be resolved

## Short example

This code:

```dart
import 'package:kiwi/kiwi.dart';

part 'test01.g.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.factory(Service, from: ServiceB)
  @Register.factory(ServiceB, name: 'factoryB')
  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  void common();

  @Register.factory(ServiceC)
  void development();

  @Register.factory(ServiceC, constructorName: 'other')
  void production();
}

class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {
  ServiceB(ServiceA serviceA);
}

class ServiceC extends Service {
  ServiceC(ServiceA serviceA, ServiceB serviceB);
  ServiceC.other(ServiceB serviceA);
}

void setup(bool isProduction) {
  var injector = _$Injector();
  injector.common();
  if (isProduction) {
    injector.production();
  } else {
    injector.development();
  }
}
```

Will produce this:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test01.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void common() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => ServiceA());
    container
        .registerFactory<Service>((c) => ServiceB(c<ServiceA>()));
    container.registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB');
    container.registerFactory(
        (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  void development() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  void production() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => ServiceC.other(c<ServiceB>()));
  }
}
```

## Changelog

Please see the [Changelog](https://github.com/vanlooverenkoen/kiwi/blob/master/kiwi_generator/CHANGELOG.md) page to know what's recently changed.
