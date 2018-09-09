// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test01.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void common() {
    final Container container = Container();
    container.registerSingleton((c) => ServiceA());
    container
        .registerFactory<Service, ServiceB>((c) => ServiceB(c<ServiceA>()));
    container.registerFactory((c) => ServiceB(c<ServiceA>()), name: 'factoryB');
    container.registerFactory(
        (c) => ServiceC(c<ServiceA>(), c<ServiceB>('factoryB')));
  }

  void development() {
    final Container container = Container();
    container.registerFactory((c) => ServiceC(c<ServiceA>(), c<ServiceB>()));
  }

  void production() {
    final Container container = Container();
    container.registerFactory((c) => ServiceC.other(c<ServiceB>()));
  }
}
