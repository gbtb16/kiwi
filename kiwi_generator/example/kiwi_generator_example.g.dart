// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiwi_generator_example.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void configureWithScopedContainer(KiwiContainer? scopedContainer) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container.registerSingleton((c) => ServiceA());
    container.registerFactory<Service>((c) => ServiceB(c<ServiceA>()));
    container.registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB');
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  @override
  void configureWithScopedContainer2([KiwiContainer? scopedContainer = null]) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  @override
  void configureWithScopedContainer3({KiwiContainer? scopedContainer = null}) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  @override
  void configureWithScopedContainer4({KiwiContainer? scopedContainer = null}) {
    final KiwiContainer container = scopedContainer ?? KiwiContainer();
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => ServiceA());
    container.registerFactory<Service>((c) => ServiceB(c<ServiceA>()));
    container.registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB');
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  @override
  void methodWithoutAnnotations() {}
}
