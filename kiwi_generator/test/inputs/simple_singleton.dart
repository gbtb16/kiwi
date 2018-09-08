import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.singleton(ServiceB, as: null)
  @Register.singleton(ServiceB, name: null)
  @Register.singleton(ServiceB, as: Service)
  @Register.singleton(ServiceA, name: 'singletonA')
  @Register.singleton(ServiceB, as: Service, name: 'singletonB')
  void configure();
}

class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {}
