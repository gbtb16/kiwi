// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test01.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerFactory((c) => Test());
    container.registerFactory((c) => Counter(c<Test>()));
    container.registerSingleton((c) => Counter(c<Test>()), name: 'display');
  }
}
