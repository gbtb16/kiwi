import 'package:kiwi_generator/src/model/kiwi_generator_error.dart';
import 'package:source_gen/source_gen.dart';
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

    test('null concrete', () async {
      await testKiwiException(
        'null_concrete_factory',
        const TypeMatcher<UnresolvedAnnotationException>(),
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

    test('null concrete', () async {
      await testKiwiException(
        'null_concrete_singleton',
        const TypeMatcher<UnresolvedAnnotationException>(),
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
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => ServiceA());
    container.registerFactory((c) => ServiceB());
    container.registerFactory((c) => ServiceB());
    container.registerFactory<Service>((c) => ServiceB());
    container.registerFactory((c) => ServiceA(), name: 'factoryA');
    container.registerFactory<Service>((c) => ServiceB(), name: 'factoryB');
  }
}
''';

const _outputComplexFactory = r'''
class _$Injector extends Injector {
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => ServiceA());
    container.registerFactory<Service>((c) => ServiceB(c<ServiceA>()));
    container.registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB');
    container.registerFactory(
        (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
    container.registerFactory((c) => ServiceC.other(c<ServiceB>()));
  }
}
''';

const _outputSimpleSingleton = r'''
class _$Injector extends Injector {
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => ServiceA());
    container.registerSingleton((c) => ServiceB());
    container.registerSingleton((c) => ServiceB());
    container.registerSingleton<Service>((c) => ServiceB());
    container.registerSingleton((c) => ServiceA(), name: 'singletonA');
    container.registerSingleton<Service>((c) => ServiceB(), name: 'singletonB');
  }
}
''';

const _outputComplexSingleton = r'''
class _$Injector extends Injector {
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => ServiceA());
    container.registerSingleton<Service>((c) => ServiceB(c<ServiceA>()));
    container.registerSingleton((c) => ServiceB(c<ServiceA>()),
        name: 'factoryB');
    container.registerSingleton(
        (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
    container.registerSingleton((c) => ServiceC.other(c<ServiceB>()));
  }
}
''';
