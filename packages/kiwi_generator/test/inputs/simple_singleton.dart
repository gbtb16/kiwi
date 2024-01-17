import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.singleton(ServiceB, from: null)
  @Register.singleton(ServiceB, name: null)
  @Register.singleton(Service, from: ServiceB)
  @Register.singleton(ServiceA, name: 'singletonA')
  @Register.singleton(Service, from: ServiceB, name: 'singletonB')
  void configure();
}

class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {}
