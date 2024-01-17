import 'package:dart_kiwi/src/models/coffee_maker.dart';
import 'package:dart_kiwi/src/models/electric_heater.dart';
import 'package:dart_kiwi/src/models/heater.dart';
import 'package:dart_kiwi/src/models/model.dart';
import 'package:dart_kiwi/src/models/pump.dart';
import 'package:dart_kiwi/src/models/thermosiphon.dart';
import 'package:kiwi/kiwi.dart';

part 'drip_coffee_module.g.dart';

abstract class CoffeeInjector {
  void configure() {
    _configureInstances();
    _configureFactories();
  }

  void _configureInstances() {
    final container = KiwiContainer();
    container.registerInstance(Model('DartCoffee', 'DripCoffeeStandard'));
  }

  @Register.factory(PowerOutlet)
  @Register.singleton(Electricity)
  @Register.singleton(Heater, from: ElectricHeater)
  @Register.singleton(Pump, from: Thermosiphon)
  @Register.factory(CoffeeMaker)
  void _configureFactories();
}

CoffeeInjector getCoffeeInjector() => _$CoffeeInjector();
