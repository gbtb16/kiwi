// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test01.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => Test())
      ..registerFactory((c) => Counter(c.resolve<Test>()))
      ..registerSingleton((c) => Counter(c.resolve<Test>()), name: 'display');
  }
}
