import 'package:kiwi/kiwi.dart';

part 'test01.g.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
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

void setup() {
  new _$Injector().configure();
}
