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

  void methodWithoutAnnotations();

  void configureInjector() {}
}

void setup() {
  final injector = _$Injector();
  injector.configure();
}

class Service {
  const Service();
}

class ServiceA extends Service {
  const ServiceA();
}

class ServiceB extends Service {
  const ServiceB(ServiceA serviceA);
}

class ServiceC extends Service {
  const ServiceC(ServiceA serviceA, ServiceB serviceB);

  const ServiceC.other(ServiceA serviceA);
}
