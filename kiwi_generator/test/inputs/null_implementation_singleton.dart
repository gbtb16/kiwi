import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.singleton(null)
  void configure();
}
