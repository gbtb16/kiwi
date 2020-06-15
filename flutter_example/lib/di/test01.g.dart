// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test01.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => Test());
    container.registerFactory((c) => Counter(c<Test>()));
    container.registerSingleton((c) => Counter(c<Test>()), name: 'display');
  }
}
