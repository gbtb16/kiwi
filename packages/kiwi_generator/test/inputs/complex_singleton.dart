import 'package:kiwi/kiwi.dart';

import '../models/service.dart';
import '../models/service_a.dart';
import '../models/service_b.dart';
import '../models/service_c.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.singleton(Service, from: ServiceB)
  @Register.singleton(ServiceB, name: 'factoryB')
  @Register.singleton(ServiceC, resolvers: {ServiceB: 'factoryB'})
  @Register.singleton(ServiceC, constructorName: 'other')
  void configure();
}
