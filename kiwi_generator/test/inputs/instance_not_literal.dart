import 'package:kiwi/kiwi.dart';

abstract class Injector {
  @Register.instance(const Person('Anakin', 'Skywalker'))
  void configure();
}

class Person {
  const Person(
    this.firstName,
    this.lastName,
  );

  final String firstName;
  final String lastName;
}
