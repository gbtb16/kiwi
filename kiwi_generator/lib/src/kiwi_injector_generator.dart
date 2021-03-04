import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:built_collection/built_collection.dart';

import 'package:build/src/builder/build_step.dart';
import 'package:kiwi_generator/src/model/kiwi_generator_error.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dart_style/dart_style.dart';

import 'package:kiwi/kiwi.dart';

const TypeChecker _registerTypeChecker = TypeChecker.fromRuntime(Register);

bool _isRegisterMethod(MethodElement method) =>
    method.returnType.isVoid &&
    _registerTypeChecker.hasAnnotationOfExact(method);

class KiwiInjectorGenerator extends Generator {
  const KiwiInjectorGenerator();

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    try {
      // An injector is an abstract class where all abstract methods are
      // annotated with Register.
      final injectors = library.classes
          .where((c) =>
              c.isAbstract &&
              c.methods.where((m) => m.isAbstract).isNotEmpty &&
              c.methods
                  .where((m) => m.isAbstract && _isRegisterMethod(m))
                  .isNotEmpty)
          .toList();

      if (injectors.isEmpty) {
        return null;
      }
      final file = Library((lb) => lb
        ..body.addAll(
            injectors.map((i) => _generateInjector(i, library, buildStep))));

      final DartEmitter emitter = DartEmitter(Allocator());
      return DartFormatter().format('${file.accept(emitter)}');
    } catch (e) {
      if (e is KiwiGeneratorError || e is UnresolvedAnnotationException) {
        rethrow;
      } else {
        throw KiwiGeneratorError(
            'Something went wrong with the KiwiGenerator. Please create a new ticket with a copy of your error to https://github.com/vanlooverenkoen/kiwi/issues/new?labels=kiwi_generator,bug',
            error: e);
      }
    }
  }

  Class _generateInjector(
      ClassElement injector, LibraryReader library, BuildStep buildStep) {
    return Class((cb) => cb
      ..name = '_\$${injector.name}'
      ..extend = refer(injector.name)
      ..methods.addAll(_generateInjectorMethods(injector)));
  }

  List<Method> _generateInjectorMethods(ClassElement injector) {
    return injector.methods
        .where((m) => m.isAbstract)
        .map((m) => _generateInjectorMethod(m))
        .toList();
  }

  Method _generateInjectorMethod(MethodElement method) {
    if (method.parameters.length > 1) {
      throw KiwiGeneratorError(
          'Only 1 parameter is supported `KiwiContainer scopedContainer`, ${method.name} contains ${method.parameters.length} param(s)');
    }
    final scopedContainerParam = method.parameters.singleWhere(
        (element) =>
            element.name == 'scopedContainer' &&
            element.type.getDisplayString(withNullability: false) ==
                'KiwiContainer',
        orElse: () => null);

    return Method.returnsVoid((mb) {
      var scopedContainer = '';
      if (scopedContainerParam != null) {
        if (scopedContainerParam.isOptional) {
          mb.optionalParameters = ListBuilder<Parameter>([
            Parameter((builder) => builder
              ..name = scopedContainerParam.name
              ..named = scopedContainerParam.isNamed
              ..required = scopedContainerParam.isRequiredNamed
              ..defaultTo = Code('null')
              ..type = Reference('KiwiContainer?'))
          ]);
        } else {
          mb.requiredParameters = ListBuilder<Parameter>([
            Parameter((builder) => builder
              ..name = scopedContainerParam.name
              ..named = scopedContainerParam.isNamed
              ..required = scopedContainerParam.isRequiredNamed
              ..defaultTo = Code('null')
              ..type = Reference('KiwiContainer?'))
          ]);
        }
        scopedContainer = '${scopedContainerParam.name} ?? ';
      } else if (method.parameters.isNotEmpty) {
        throw KiwiGeneratorError(
            'Only 1 parameter is supported `KiwiContainer scopedContainer`, ${method.name} contains ${method.parameters.length} param(s) and `KiwiContainer scopedContainer` is not included');
      }
      final registers = _generateRegisters(method);
      mb
        ..name = method.name
        ..annotations.add(refer('override'));
      if (registers.isEmpty) {
        mb..body = Block();
      } else {
        mb
          ..body = Block((bb) => bb
            ..statements.add(Code(
                'final KiwiContainer container = ${scopedContainer}KiwiContainer();'))
            ..statements.addAll(registers));
      }
      return mb;
    });
  }

  List<Code> _generateRegisters(MethodElement method) {
    return _registerTypeChecker
        .annotationsOfExact(method)
        .map((a) =>
            _generateRegister(AnnotatedElement(ConstantReader(a), method)))
        .toList();
  }

  Code _generateRegister(AnnotatedElement annotatedMethod) {
    final ConstantReader annotation = annotatedMethod.annotation;
    final DartObject registerObject = annotation.objectValue;

    final String name = registerObject.getField('name').toStringValue();
    final DartType type = registerObject.getField('type').toTypeValue();
    final DartType concrete = registerObject.getField('from').toTypeValue();
    final DartType concreteType = concrete ?? type;

    final String className =
        concreteType.getDisplayString(withNullability: false);
    final String typeParameters = concrete == null
        ? ''
        : '<${type.getDisplayString(withNullability: false)}>';

    final String nameArgument = name == null ? '' : ", name: '$name'";
    final String constructorName =
        registerObject.getField('constructorName').toStringValue();
    final String constructorNameArgument =
        constructorName == null ? '' : '.$constructorName';

    final ClassElement clazz = concreteType.element.library.getType(className);
    if (clazz == null) {
      throw KiwiGeneratorError('$className not found');
    }

    final bool oneTime =
        registerObject.getField('oneTime').toBoolValue() ?? false;
    final Map<DartType, String> resolvers =
        _computeResolvers(registerObject.getField('resolvers').toMapValue());

    final String methodSuffix = oneTime ? 'Singleton' : 'Factory';

    final constructor = constructorName == null
        ? clazz.unnamedConstructor
        : clazz.getNamedConstructor(constructorName);

    if (constructor == null) {
      throw KiwiGeneratorError(
          'the constructor ${clazz.name}.$constructorName does not exist');
    }

    final String factoryParameters = _generateRegisterArguments(
      constructor,
      resolvers,
    ).join(', ');

    return Code(
        'container.register$methodSuffix$typeParameters((c) => $className$constructorNameArgument($factoryParameters)$nameArgument);');
  }

  List<String> _generateRegisterArguments(
    ConstructorElement constructor,
    Map<DartType, String> resolvers,
  ) {
    return constructor.parameters
        .map((p) => _generateRegisterArgument(p, resolvers))
        .toList();
  }

  String _generateRegisterArgument(
    ParameterElement parameter,
    Map<DartType, String> resolvers,
  ) {
    final String name = resolvers == null ? null : resolvers[parameter.type];
    final String nameArgument = name == null ? '' : "'$name'";
    return '${parameter.isNamed ? parameter.name + ': ' : ''}c<${parameter.type.getDisplayString(withNullability: false)}>($nameArgument)';
  }

  Map<DartType, String> _computeResolvers(
    Map<DartObject, DartObject> resolvers,
  ) {
    return resolvers?.map((key, value) =>
        MapEntry<DartType, String>(key.toTypeValue(), value.toStringValue()));
  }
}
