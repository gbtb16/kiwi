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

    test('null implementation', () async {
      await testKiwiException(
        'null_implementation_factory',
        const TypeMatcher<UnresolvedAnnotationException>(),
      );
    });

    test('unknown constructor', () async {
      await testKiwiException(
        'unknown_ctor_factory',
        const TypeMatcher<ArgumentError>().having(
          (f) => f.message,
          'message',
          'the constructor Service.unknown does not exist',
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

    test('null implementation', () async {
      await testKiwiException(
        'null_implementation_singleton',
        const TypeMatcher<UnresolvedAnnotationException>(),
      );
    });

    test('unknown constructor', () async {
      await testKiwiException(
        'unknown_ctor_singleton',
        const TypeMatcher<ArgumentError>().having(
          (f) => f.message,
          'message',
          'the constructor Service.unknown does not exist',
        ),
      );
    });
  });
}

const _outputSimpleFactory = r'''
class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerFactory((c) => ServiceA());
    container.registerFactory((c) => ServiceB());
    container.registerFactory((c) => ServiceB());
    container.registerFactory<Service, ServiceB>((c) => ServiceB());
    container.registerFactory((c) => ServiceA(), name: 'factoryA');
    container.registerFactory<Service, ServiceB>((c) => ServiceB(),
        name: 'factoryB');
  }
}
''';

const _outputComplexFactory = r'''
class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerFactory((c) => ServiceA());
    container
        .registerFactory<Service, ServiceB>((c) => ServiceB(c<ServiceA>()));
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
    final Container container = Container();
    container.registerSingleton((c) => ServiceA());
    container.registerSingleton((c) => ServiceB());
    container.registerSingleton((c) => ServiceB());
    container.registerSingleton<Service, ServiceB>((c) => ServiceB());
    container.registerSingleton((c) => ServiceA(), name: 'singletonA');
    container.registerSingleton<Service, ServiceB>((c) => ServiceB(),
        name: 'singletonB');
  }
}
''';

const _outputComplexSingleton = r'''
class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerSingleton((c) => ServiceA());
    container
        .registerSingleton<Service, ServiceB>((c) => ServiceB(c<ServiceA>()));
    container.registerSingleton((c) => ServiceB(c<ServiceA>()),
        name: 'factoryB');
    container.registerSingleton(
        (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
    container.registerSingleton((c) => ServiceC.other(c<ServiceB>()));
  }
}
''';
