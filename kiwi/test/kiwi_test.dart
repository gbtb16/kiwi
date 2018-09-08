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

      expect(container.resolve<int>(), 5);
      expect(container.resolve<int>('named'), 6);
      expect(container.resolve<num>(), 7);
      expect(container.resolve<num>('named'), null);
      expect(container.resolve<Person>(), person);
    });

    test('container should resolve when called', () {
      var person = Person('Anakin', 'Skywalker');
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');
      container.registerInstance<num, int>(
        7,
      );
      container.registerInstance(person);

      expect(container<int>(), 5);
      expect(container<int>('named'), 6);
      expect(container<num>(), 7);
      expect(container<num>('named'), null);
      expect(container<Person>(), person);
    });

    test('instances can be overridden', () {
      container.registerInstance(5);
      expect(container.resolve<int>(), 5);

      container.registerInstance(6);
      expect(container.resolve<int>(), 6);
    });

    test('builders should be resolved', () {
      container.registerSingleton((c) => 5);
      container.registerFactory(
          (c) => const Employee('Anakin', 'Skywalker', 'DARK'));
      container.registerFactory<Person, Employee>(
          (c) => const Person('Anakin', 'Skywalker'));

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Employee>(),
          const Employee('Anakin', 'Skywalker', 'DARK'));
      expect(container.resolve<Person>(), const Person('Anakin', 'Skywalker'));
    });

    test('builders should always be created', () {
      container.registerFactory((c) => Person('Anakin', 'Skywalker'));

      expect(container.resolve<Person>(),
          isNot(same(container.resolve<Person>())));
    });

    test('one time builders should be resolved', () {
      container.registerSingleton((c) => 5);
      container.registerSingleton(
          (c) => const Employee('Anakin', 'Skywalker', 'DARK'));
      container.registerSingleton<Person, Employee>(
          (c) => const Person('Anakin', 'Skywalker'));

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Employee>(),
          const Employee('Anakin', 'Skywalker', 'DARK'));
      expect(container.resolve<Person>(), const Person('Anakin', 'Skywalker'));
    });

    test('one time builders should be created one time only', () {
      container.registerSingleton((c) => Person('Anakin', 'Skywalker'));

      expect(container.resolve<Person>(), container.resolve<Person>());
    });

    test('unregister should remove items from container', () {
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');

      expect(container.resolve<int>(), 5);
      expect(container.resolve<int>('named'), 6);

      container.unregister<int>();
      expect(container.resolve<int>(), null);

      container.unregister<int>('named');
      expect(container.resolve<int>('named'), null);
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
