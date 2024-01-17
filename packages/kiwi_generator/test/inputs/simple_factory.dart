import 'package:kiwi/kiwi.dart';

import '../models/service.dart';
import '../models/service_a.dart';

abstract class Injector {
  @Register.factory(ServiceA)
  @Register.factory(LocalService, from: null)
  @Register.factory(LocalService, name: null)
  @Register.factory(Service, from: LocalService)
  @Register.factory(ServiceA, name: 'factoryA')
  @Register.factory(Service, from: LocalService, name: 'factoryLocalService')
  void configure();
}

class LocalService extends Service {
  const LocalService();
}
