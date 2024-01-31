import 'package:dart_kiwi/src/models/heater.dart';

class PowerOutlet {
  const PowerOutlet();
}

class Electricity {
  const Electricity(PowerOutlet outlet);
}

class ElectricHeater implements Heater {
  ElectricHeater(Electricity electricity);

  bool _heating = false;

  @override
  void on() {
    print('heating');
    _heating = true;
  }

  @override
  void off() {
    _heating = false;
  }

  @override
  bool get isHot => _heating;
}
