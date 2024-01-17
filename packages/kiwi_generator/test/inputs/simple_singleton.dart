import 'package:kiwi/kiwi.dart';

import '../models/service.dart';
import '../models/service_a.dart';
import '../models/service_b.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.singleton(ServiceB, from: null)
  @Register.singleton(ServiceB, name: null)
  @Register.singleton(Service, from: ServiceB)
  @Register.singleton(ServiceA, name: 'singletonA')
  @Register.singleton(Service, from: ServiceB, name: 'singletonB')
  void configure();
}
