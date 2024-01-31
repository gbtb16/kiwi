// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drip_coffee_module.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$CoffeeInjector extends CoffeeInjector {
  @override
  void _configureFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => PowerOutlet())
      ..registerSingleton((c) => Electricity(c<PowerOutlet>()))
      ..registerSingleton<Heater>((c) => ElectricHeater(c<Electricity>()))
      ..registerSingleton<Pump>((c) => Thermosiphon(c<Heater>()))
      ..registerFactory((c) => CoffeeMaker(c<Heater>(), c<Pump>(), c<Model>()));
  }
}
