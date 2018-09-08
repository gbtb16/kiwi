import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.singleton(ServiceB, as: Service)
  @Register.singleton(ServiceB, name: 'factoryB')
  @Register.singleton(ServiceC, resolvers: {ServiceB: 'factoryB'})
  @Register.singleton(ServiceC, constructorName: 'other')
  void configure();
}

class Service {}

class ServiceA extends Service {}

class ServiceB extends Service {
  ServiceB(ServiceA serviceA);
}

class ServiceC extends Service {
  ServiceC(ServiceA serviceA, ServiceB serviceB);
  ServiceC.other(ServiceB serviceA);
}
