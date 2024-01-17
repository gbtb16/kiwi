import 'package:kiwi/kiwi.dart';

part 'test01.g.dart';

abstract class Injector {
  @Register.factory(Test)
  @Register.factory(Counter)
  @Register.singleton(Counter, name: 'display')
  void configure();
}

class Test {}

class Counter {
  int _value = 0;

  Counter(Test test);

  int get value => _value;

  void add() => _value++;
}

class Di {
  static void setup() {
    var injector = _$Injector();
    injector.configure();
  }
}
