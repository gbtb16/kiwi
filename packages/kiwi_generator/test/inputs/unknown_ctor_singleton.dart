import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.factory(Service, constructorName: 'unknown')
  void configure();
}

class Service {
  Service.other();
}
