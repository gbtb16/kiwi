import 'package:kiwi/kiwi.dart';

import '../models/local_service.dart';
import '../models/service.dart';
import '../models/service_a.dart';

abstract class Injector {
  @Register.singleton(ServiceA)
  @Register.singleton(LocalService, from: null)
  @Register.singleton(LocalService, name: null)
  @Register.singleton(Service, from: LocalService)
  @Register.singleton(ServiceA, name: 'singletonA')
  @Register.singleton(Service, from: LocalService, name: 'singletonLocalService')
  void configure();
}
