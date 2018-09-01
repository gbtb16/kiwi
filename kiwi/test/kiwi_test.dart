import 'package:kiwi/kiwi.dart';
import 'package:test/test.dart';

void main() {
  Container container = Container();
  group('Container tests', () {
    setUp(() {
      container.clear();
    });

    test('containers should be the same', () {
      Container c1 = Container();
      Container c2 = Container();
      expect(c1, c2);
    });

    test('instances should be resolved', () {
      var person = Person('Anakin', 'Skywalker');
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');
      container.registerInstance<num, int>(
        7,
      );
      container.registerInstance(person);

      expect(container.get<int>(), 5);
      expect(container.get<int>('named'), 6);
      expect(container.get<num>(), 7);
      expect(container.get<num>('named'), null);
      expect(container.get<Person>(), person);
    });

    test('instances can be overridden', () {
      container.registerInstance(5);
      expect(container.get<int>(), 5);

      container.registerInstance(6);
      expect(container.get<int>(), 6);
    });

    test('builders should be resolved', () {
      container.registerBuilder((c) => 5, oneTime: true);
      container.registerBuilder(
          (c) => const Employee('Anakin', 'Skywalker', 'DARK'));
      container.registerBuilder<Person, Employee>(
          (c) => const Person('Anakin', 'Skywalker'));

      expect(container.get<int>(), 5);
      expect(container.get<Employee>(),
          const Employee('Anakin', 'Skywalker', 'DARK'));
      expect(container.get<Person>(), const Person('Anakin', 'Skywalker'));
    });

    test('builders should always be created', () {
      container.registerBuilder((c) => Person('Anakin', 'Skywalker'));

      expect(container.get<Person>(), isNot(same(container.get<Person>())));
    });

    test('one time builders should be resolved', () {
      container.registerBuilder((c) => 5, oneTime: true);
      container.registerBuilder(
          (c) => const Employee('Anakin', 'Skywalker', 'DARK'),
          oneTime: true);
      container.registerBuilder<Person, Employee>(
          (c) => const Person('Anakin', 'Skywalker'),
          oneTime: true);

      expect(container.get<int>(), 5);
      expect(container.get<Employee>(),
          const Employee('Anakin', 'Skywalker', 'DARK'));
      expect(container.get<Person>(), const Person('Anakin', 'Skywalker'));
    });

    test('one time builders should be created one time only', () {
      container.registerBuilder((c) => Person('Anakin', 'Skywalker'),
          oneTime: true);

      expect(container.get<Person>(), container.get<Person>());
    });
  });
}

class Person {
  const Person(
    this.firstName,
    this.lastName,
  );

  final String firstName;
  final String lastName;
}

class Employee extends Person {
  const Employee(
    String firstName,
    String lastName,
    this.id,
  ) : super(firstName, lastName);

  final String id;
}
