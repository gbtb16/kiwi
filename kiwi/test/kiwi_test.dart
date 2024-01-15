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
      container.registerInstance<num>(7);
      container.registerInstance(person);

      expect(container.resolve<int>(), 5);
      expect(container.resolve<int>('named'), 6);
      expect(container.resolve<num>(), 7);

      expect(
          () => container.resolve<num>('named'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `num`:\n\nThe type `num` was not registered for the name `named`\n\nMake sure `num` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));
    });

    test('instances should be resolveAs', () {
      final sith = Sith('Anakin', 'Skywalker', 'DartVader');
      container.registerSingleton<Character>((c) => sith);

      expect(container.resolveAs<Character, Sith>(), sith);

      expect(
          () => container.resolveAs<Character, Sith>('named'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `Character`:\n\nThe type `Character` was not registered for the name `named`\n\nMake sure `Character` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));
    });

    test('container should resolve when called', () {
      var person = Character('Anakin', 'Skywalker');
      container.registerInstance(5);
      container.registerInstance(6, name: 'named');
      container.registerInstance<num>(7);
      container.registerInstance(person);

      expect(container<int>(), 5);
      expect(container<int>('named'), 6);
      expect(container<num>(), 7);
      expect(
          () => container.resolve<num>('named'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `num`:\n\nThe type `num` was not registered for the name `named`\n\nMake sure `num` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));
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
      container.registerFactory((c) => const Character('Anakin', 'Skywalker'));
      container.registerFactory<Character>(
          (c) => const Sith('Anakin', 'Skywalker', 'DartVader'),
          name: 'named');

      expect(container.resolve<int>(), 5);
      expect(container.resolve<Sith>(),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
      expect(container.resolve<Character>(),
          const Character('Anakin', 'Skywalker'));
      expect(container.resolve<Character>('named'),
          const Sith('Anakin', 'Skywalker', 'DartVader'));
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
      container.registerSingleton<Character>(
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
      expect(
          () => container.resolve<int>(),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `int`:\n\nThe type `int` was not registered\n\nMake sure `int` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));

      container.unregister<int>('named');
      expect(
          () => container.resolve<int>('named'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `int`:\n\nThe type `int` was not registered for the name `named`\n\nMake sure `int` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));
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
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'KiwiError:\n\n\nThe type `int` was already registered\n\n\n',
          )));

      expect(
          () => container.registerInstance(9, name: 'name'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'KiwiError:\n\n\nThe type `int` was already registered for the name `name`\n\n\n',
          )));
    });

    test('values should exist when unregistering', () {
      expect(
          () => container.unregister<int>(),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'KiwiError:\n\n\nFailed to unregister `int`:\n\nThe type `int` was not registered\n\nMake sure `int` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));

      expect(
          () => container.unregister<int>('name'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'KiwiError:\n\n\nFailed to unregister `int`:\n\nThe type `int` was not registered for the name `name`\n\nMake sure `int` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));
    });

    test('values should exist when resolving', () {
      expect(
          () => container.resolve<int>(),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `int`:\n\nThe type `int` was not registered\n\nMake sure `int` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));

      expect(
          () => container.resolve<int>('name'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'Not Registered KiwiError:\n\n\nFailed to resolve `int`:\n\nThe type `int` was not registered for the name `name`\n\nMake sure `int` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));
    });
    test('values should exist when resolving as', () {
      var person = Character('Anakin', 'Skywalker');
      container.registerInstance(person);
      container.registerInstance(person, name: 'named');
      expect(
          () => container.resolveAs<Character, Sith>(),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'KiwiError:\n\n\nFailed to resolve `Character` as `Sith`:\n\nThe type `Character` as `Sith` was not registered\n\nMake sure `Sith` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
          )));

      expect(
          () => container.resolveAs<Character, Sith>('named'),
          throwsA(TypeMatcher<KiwiError>().having(
            (f) => f.toString(),
            'toString()',
            'KiwiError:\n\n\nFailed to resolve `Character` as `Sith`:\n\nThe type `Character` as `Sith` was not registered for the name `named`\n\nMake sure `Sith` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.\n\n\n',
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
