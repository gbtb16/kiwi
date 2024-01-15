// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiwi_generator_example.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void configureWithScopedContainer(KiwiContainer? scopedContainer) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container
      ..registerSingleton((c) => ServiceA())
      ..registerFactory<Service>((c) => ServiceB(c<ServiceA>()))
      ..registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB')
      ..registerFactory(
          (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  @override
  void configureWithScopedContainer2([KiwiContainer? scopedContainer = null]) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container
      ..registerFactory(
          (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  @override
  void configureWithScopedContainer3({KiwiContainer? scopedContainer = null}) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container
      ..registerFactory(
          (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  @override
  void configureWithScopedContainer4({KiwiContainer? scopedContainer = null}) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container
      ..registerFactory(
          (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => ServiceA())
      ..registerFactory<Service>((c) => ServiceB(c<ServiceA>()))
      ..registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB')
      ..registerFactory(
          (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  @override
  void methodWithoutAnnotations() {}
}
