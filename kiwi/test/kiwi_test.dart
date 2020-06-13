import 'package:kiwi/kiwi.dart';
import 'package:test/test.dart';

void main() {
  KiwiContainer container = KiwiContainer();

  group('Silent=true tests', () {
    setUp(() {
      container.clear();
      container.silent = true;
    });

    test('containers should be the same', () {
      KiwiContainer c1 = KiwiContainer();
      KiwiContainer c2 = KiwiContainer();
      expect(c1, c2);
    });

    test('KiwiContainer.scope should be a different object', () {
      KiwiContainer c1 = KiwiContainer();
      KiwiContainer c2 = KiwiContainer();
      KiwiContainer c3 = KiwiContainer.scoped();
      KiwiContainer c4 = KiwiContainer.scoped();
      expect(c1, c2);
      expect(c1, isNot(c3));
      expect(c1, isNot(c4));
      expect(c2, isNot(c3));
      expect(c2, isNot(c4));
      expect(c3, isNot(c4));
    });

    test('instances should be resolved', () {
      var person = Character('Anakin', 'Skywalker');
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
      expect(container.resolve<Character>(), person);
    });

    test('container should resolve when called', () {
      var person = Character('Anakin', 'Skywalker');
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
      expect(container<Character>(), person);
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
          (c) => const Sith('Anakin', 'Skywalker', 'DartVader'));
      container.registerFactory<Character, Sith>(
          (c) => const Character('Anakin', 'Skywalker'));

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Sith>(),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
      expect(container.resolve<Character>(),
          const Character('Anakin', 'Skywalker'));
    });

    test('builders should always be created', () {
      container.registerFactory((c) => Character('Anakin', 'Skywalker'));

      expect(container.resolve<Character>(),
          isNot(same(container.resolve<Character>())));
    });

    test('one time builders should be resolved', () {
      container.registerSingleton((c) => 5);
      container.registerSingleton(
          (c) => const Sith('Anakin', 'Skywalker', 'DartVader'));
      container.registerSingleton<Character, Sith>(
          (c) => const Character('Anakin', 'Skywalker'));

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Sith>(),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
      expect(container.resolve<Character>(),
          const Character('Anakin', 'Skywalker'));
    });

    test('one time builders should be created one time only', () {
      container.registerSingleton((c) => Character('Anakin', 'Skywalker'));

      expect(container.resolve<Character>(), container.resolve<Character>());
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

  group('Silent=false tests', () {
    setUp(() {
      container.clear();
      container.silent = false;
    });

    test('instances cannot be overridden', () {
      container.registerInstance(5);
      expect(container.resolve<int>(), 5);

      container.registerInstance(8, name: 'name');
      expect(container.resolve<int>('name'), 8);

      expect(
          () => container.registerInstance(6),
          throwsA(TypeMatcher<AssertionError>().having(
            (f) => f.message,
            'message',
            'The type `int` was already registered',
          )));

      expect(
          () => container.registerInstance(9, name: 'name'),
          throwsA(TypeMatcher<AssertionError>().having(
            (f) => f.message,
            'message',
            'The type `int` was already registered for the name `name`',
          )));
    });

    test('values should exist when unregistering', () {
      expect(
          () => container.unregister<int>(),
          throwsA(TypeMatcher<AssertionError>().having(
            (f) => f.message,
            'message',
            'Failed to unregister `int`:\nThe type `int` was not registered\nMake sure `int` is added to your KiwiContainer and rerun flutter build',
          )));

      expect(
          () => container.unregister<int>('name'),
          throwsA(TypeMatcher<AssertionError>().having(
            (f) => f.message,
            'message',
            'Failed to unregister `int`:\nThe type `int` was not registered for the name `name`\nMake sure `int` is added to your KiwiContainer and rerun flutter build',
          )));
    });

    test('values should exist when resolving', () {
      expect(
          () => container.resolve<int>(),
          throwsA(TypeMatcher<AssertionError>().having(
            (f) => f.message,
            'message',
            'Failed to resolve `int`:\nThe type `int` was not registered\nMake sure `int` is added to your KiwiContainer and rerun flutter build',
          )));

      expect(
          () => container.resolve<int>('name'),
          throwsA(TypeMatcher<AssertionError>().having(
            (f) => f.message,
            'message',
            'Failed to resolve `int`:\nThe type `int` was not registered for the name `name`\nMake sure `int` is added to your KiwiContainer and rerun flutter build',
          )));
    });
  });
}

class Character {
  const Character(
    this.firstName,
    this.lastName,
  );

  final String firstName;
  final String lastName;
}

class Sith extends Character {
  const Sith(
    String firstName,
    String lastName,
    this.id,
  ) : super(firstName, lastName);

  final String id;
}
