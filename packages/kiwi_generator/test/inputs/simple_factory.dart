import 'package:kiwi/kiwi.dart';

import '../models/service.dart';
import '../models/service_a.dart';
import '../models/service_b.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(ServiceB, from: null)
  @Register.factory(ServiceB, name: null)
  @Register.factory(Service, from: ServiceB)
  @Register.factory(ServiceA, name: 'factoryA')
  @Register.factory(Service, from: ServiceB, name: 'factoryB')
  void configure();
}
