import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(ServiceB, as: Service)
  @Register.factory(ServiceB, name: 'factoryB')
  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  @Register.factory(ServiceC, constructorName: 'other')
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
