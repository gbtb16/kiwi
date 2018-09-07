import 'package:test/test.dart';

import 'utils/test.dart';

void main() async {
  group('input files', () {
    test('Register.instance - int', () async {
      await testKiwi(
        'instance_int',
        _outputInstanceInt,
      );
    });

    test('Register.instance - not literal', () async {
      await testKiwiException(
        'instance_not_literal',
        const TypeMatcher<ArgumentError>().having((e) => e.message, 'message',
            'The instance argument should be a literal'),
      );
    });
  });
}

const _outputInstanceInt = r'''
class _Injector extends Injector {
  const _Injector();

  void configure() {
    final Container container = Container();
    container.registerInstance(5);
  }
}
''';
