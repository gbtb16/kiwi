import 'package:kiwi/kiwi.dart';

import '../models/unknown_service.dart';

abstract class Injector {
  @Register.factory(UnknownService, constructorName: 'unknown')
  void configure();
}
