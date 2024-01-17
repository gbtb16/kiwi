import 'package:dart_kiwi/src/models/coffee_maker.dart';
import 'package:dart_kiwi/src/modules/drip_coffee_module.dart';
import 'package:kiwi/kiwi.dart';

void main(List<String> arguments) async {
  CoffeeInjector coffeeInjector = getCoffeeInjector();
  coffeeInjector.configure();

  final container = KiwiContainer();

  CoffeeMaker coffeeMaker = container<CoffeeMaker>();
  coffeeMaker.brew();
}
