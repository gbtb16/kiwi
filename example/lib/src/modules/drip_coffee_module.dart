import 'package:example/src/models/coffee_maker.dart';
import 'package:example/src/models/electric_heater.dart';
import 'package:example/src/models/heater.dart';
import 'package:example/src/models/model.dart';
import 'package:example/src/models/pump.dart';
import 'package:example/src/models/thermosiphon.dart';
import 'package:kiwi/kiwi.dart';

part 'drip_coffee_module.g.dart';

abstract class CoffeeInjector {
  void configure() {
    _configureInstances();
    _configureFactories();
  }

  void _configureInstances() {
    Container container = Container();
    container.registerInstance(new Model('DartCoffee', 'DripCoffeeStandard'));
  }

  @Register.factory(PowerOutlet)
  @Register.singleton(Electricity)
  @Register.singleton(Heater, from: ElectricHeater)
  @Register.singleton(Pump, from: Thermosiphon)
  @Register.factory(CoffeeMaker)
  void _configureFactories();
}

CoffeeInjector getCoffeeInjector() => new _$CoffeeInjector();
