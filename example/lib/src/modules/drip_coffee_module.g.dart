// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drip_coffee_module.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$CoffeeInjector extends CoffeeInjector {
  void _configureFactories() {
    final Container container = Container();
    container.registerFactory((c) => PowerOutlet());
    container.registerSingleton((c) => Electricity(c<PowerOutlet>()));
    container.registerSingleton<Heater, ElectricHeater>(
        (c) => ElectricHeater(c<Electricity>()));
    container.registerSingleton<Pump, Thermosiphon>(
        (c) => Thermosiphon(c<Heater>()));
    container.registerFactory(
        (c) => CoffeeMaker(c<Heater>(), c<Pump>(), c<Model>()));
  }
}
