import 'package:example/src/models/heater.dart';
import 'package:example/src/models/pump.dart';

class Thermosiphon implements Pump {
  final Heater _heater;
  
  Thermosiphon(this._heater);

  @override
  void pump() {
    if (_heater.isHot) {
      print('pumping water');
    }
  }
}