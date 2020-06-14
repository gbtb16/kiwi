import 'package:kiwi/kiwi.dart';

part 'kiwi_generator_example.g.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.factory(Service, from: ServiceB)
  @Register.factory(ServiceB, name: 'factoryB')
  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  void configureWithScopedContainer(KiwiContainer scopedContainer);

  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  void configureWithScopedContainer2([KiwiContainer scopedContainer]);

  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  void configureWithScopedContainer3({KiwiContainer scopedContainer});

  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  void configureWithScopedContainer4({KiwiContainer scopedContainer});

  @Register.singleton(ServiceA)
  @Register.factory(Service, from: ServiceB)
  @Register.factory(ServiceB, name: 'factoryB')
  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
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
  var injector = _$Injector();
  injector.configure();
}
