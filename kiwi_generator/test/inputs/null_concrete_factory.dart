import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.factory(null)
  void configure();
}
