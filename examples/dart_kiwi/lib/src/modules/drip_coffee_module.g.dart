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
      ..registerSingleton((c) => Electricity(c.resolve<PowerOutlet>()))
      ..registerSingleton<Heater>(
          (c) => ElectricHeater(c.resolve<Electricity>()))
      ..registerSingleton<Pump>((c) => Thermosiphon(c.resolve<Heater>()))
      ..registerFactory((c) => CoffeeMaker(
          c.resolve<Heater>(), c.resolve<Pump>(), c.resolve<Model>()));
  }
}
