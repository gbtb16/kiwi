import 'package:dart_kiwi/src/models/heater.dart';
import 'package:dart_kiwi/src/models/pump.dart';

class Thermosiphon implements Pump {
  final Heater _heater;

  const Thermosiphon(this._heater);

  @override
  void pump() {
    if (_heater.isHot) {
      print('pumping water');
    }
  }
}
