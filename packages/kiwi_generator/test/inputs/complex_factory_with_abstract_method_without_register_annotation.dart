import 'package:kiwi/kiwi.dart';

import '../models/service.dart';
import '../models/service_a.dart';
import '../models/service_b.dart';
import '../models/service_c.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(Service, from: ServiceB)
  @Register.factory(ServiceB, name: 'factoryB')
  @Register.factory(ServiceC, resolvers: {ServiceB: 'factoryB'})
  @Register.factory(ServiceC, constructorName: 'other')
  void configure();

  void abstractMethodWithoutAnnotation();
}
