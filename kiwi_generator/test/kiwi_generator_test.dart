import 'package:kiwi_generator/src/model/kiwi_generator_error.dart';
import 'package:test/test.dart';

import 'utils/test.dart';

void main() async {
  group('Register.factory', () {
    test('simple', () async {
      await testKiwi(
        'simple_factory',
        _outputSimpleFactory,
      );
    });

    test('complex', () async {
      await testKiwi(
        'complex_factory',
        _outputComplexFactory,
      );
    });

    test('abstract class without abstract method', () async {
      await testKiwi(
        'complex_factory_with_abstract_method_without_register_annotation',
        _outputComplexFactoryWithAbstractMethodWithoutAnnotation,
      );
    });

    test('unknown constructor', () async {
      await testKiwiException(
        'unknown_ctor_factory',
        const TypeMatcher<KiwiGeneratorError>().having(
          (f) => f.toString(),
          'toString()',
          '\nKiwiGeneratorError\n\nthe constructor Service.unknown does not exist\n\n',
        ),
      );
    });
  });

  group('Register.singleton', () {
    test('simple', () async {
      await testKiwi(
        'simple_singleton',
        _outputSimpleSingleton,
      );
    });

    test('complex', () async {
      await testKiwi(
        'complex_singleton',
        _outputComplexSingleton,
      );
    });

    test('unknown constructor', () async {
      await testKiwiException(
        'unknown_ctor_singleton',
        const TypeMatcher<KiwiGeneratorError>().having(
          (f) => f.toString(),
          'toString()',
          '\nKiwiGeneratorError\n\nthe constructor Service.unknown does not exist\n\n',
        ),
      );
    });
  });

  group('Generates null', () {
    test('abstract class', () async {
      await testKiwi(
        'abstract_class',
        null,
      );
    });

    test('abstract class without method', () async {
      await testKiwi(
        'abstract_class_without_method',
        null,
      );
    });

    test('abstract class without abstract method', () async {
      await testKiwi(
        'abstract_class_without_abstract_method',
        null,
      );
    });
  });
}

const _outputSimpleFactory = r'''
class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => ServiceA())
      ..registerFactory((c) => ServiceB())
      ..registerFactory((c) => ServiceB())
      ..registerFactory<Service>((c) => ServiceB())
      ..registerFactory((c) => ServiceA(), name: 'factoryA')
      ..registerFactory<Service>((c) => ServiceB(), name: 'factoryB');
  }
}
''';

const _outputComplexFactory = r'''
class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => ServiceA())
      ..registerFactory<Service>((c) => ServiceB(c<ServiceA>()))
      ..registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB')
      ..registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')))
      ..registerFactory((c) => ServiceC.other(c<ServiceB>()));
  }
}
''';

const _outputComplexFactoryWithAbstractMethodWithoutAnnotation = r'''
class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => ServiceA())
      ..registerFactory<Service>((c) => ServiceB(c<ServiceA>()))
      ..registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB')
      ..registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')))
      ..registerFactory((c) => ServiceC.other(c<ServiceB>()));
  }

  @override
  void abstractMethodWithoutAnnotation() {}
}
''';

const _outputSimpleSingleton = r'''
class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => ServiceA())
      ..registerSingleton((c) => ServiceB())
      ..registerSingleton((c) => ServiceB())
      ..registerSingleton<Service>((c) => ServiceB())
      ..registerSingleton((c) => ServiceA(), name: 'singletonA')
      ..registerSingleton<Service>((c) => ServiceB(), name: 'singletonB');
  }
}
''';

const _outputComplexSingleton = r'''
class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => ServiceA())
      ..registerSingleton<Service>((c) => ServiceB(c<ServiceA>()))
      ..registerSingleton((c) => ServiceB(c<ServiceA>()), name: 'factoryB')
      ..registerSingleton(
          (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')))
      ..registerSingleton((c) => ServiceC.other(c<ServiceB>()));
  }
}
''';
