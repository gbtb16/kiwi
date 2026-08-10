import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(ServiceB)
  @Register.factory(ServiceC)
  void configure();
}

class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {
  ServiceB(ServiceA? serviceA);
}

class ServiceC extends Service {
  ServiceC({ServiceA? serviceA, required ServiceB serviceB});
}
