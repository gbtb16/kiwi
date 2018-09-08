import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(ServiceB, as: null)
  @Register.factory(ServiceB, name: null)
  @Register.factory(ServiceB, as: Service)
  @Register.factory(ServiceA, name: 'factoryA')
  @Register.factory(ServiceB, as: Service, name: 'factoryB')
  void configure();
}

class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {}
