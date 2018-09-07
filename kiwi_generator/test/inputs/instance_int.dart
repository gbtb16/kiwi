import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.instance(5)
  void configure();
}
