import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';

import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dart_style/dart_style.dart';

import 'package:kiwi/kiwi.dart';

const TypeChecker _registerTypeChecker =
    const TypeChecker.fromRuntime(Register);

bool _isRegisterMethod(MethodElement method) =>
    method.returnType.isVoid &&
    _registerTypeChecker.hasAnnotationOfExact(method);

class InjectorGenerator extends Generator {
  const InjectorGenerator();

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    // An injector is an abstract class where all abstract methods are
    // annotated with Register.
    final injectors = library.classElements.where((c) =>
        c.isAbstract &&
        c.methods
            .where((m) => m.isAbstract)
            .every((m) => _isRegisterMethod(m)));

    final file = Library((lb) => lb
      ..body.add(Directive.import('package:kiwi/kiwi.dart'))
      ..body.addAll(
          injectors.map((i) => _generateInjector(i, library, buildStep))));

    final DartEmitter emitter = DartEmitter(Allocator());
    return DartFormatter().format('${file.accept(emitter)}');
  }

  Class _generateInjector(
      ClassElement injector, LibraryReader library, BuildStep buildStep) {
    return Class((cb) => cb
      ..name = '_${injector.name}'
      ..extend = refer(injector.name, injector.librarySource.uri.toString())
      ..methods.addAll(_generateInjectorMethods(injector, library, buildStep)));
  }

  List<Method> _generateInjectorMethods(
      ClassElement injector, LibraryReader library, BuildStep buildStep) {
    return injector.methods
        .where((m) => m.isAbstract && _isRegisterMethod(m))
        .map((m) => _generateInjectorMethod(m, library, buildStep))
        .toList();
  }

  Method _generateInjectorMethod(
      MethodElement method, LibraryReader library, BuildStep buildStep) {
    return Method.returnsVoid((mb) => mb
      ..name = method.name
      ..body = Block((bb) => bb
        ..statements.add(Code('final Container container = Container();'))
        ..statements.addAll(_generateRegisters(method, library, buildStep))));
  }

  List<Code> _generateRegisters(
      MethodElement method, LibraryReader library, BuildStep buildStep) {
    return _registerTypeChecker
        .annotationsOfExact(method)
        .map((a) => _generateRegister(
            AnnotatedElement(ConstantReader(a), method), library, buildStep))
        .toList();
  }

  Code _generateRegister(AnnotatedElement annotatedMethod,
      LibraryReader library, BuildStep buildStep) {
    final ConstantReader annotation = annotatedMethod.annotation;
    final DartObject registerObject = annotatedMethod.annotation.objectValue;

    final DartObject object = registerObject.getField('object');
    final String name = registerObject.getField('name').toStringValue();
    final DartType implementation =
        registerObject.getField('implementation').toTypeValue();
    final DartType abstraction = registerObject.getField('as').toTypeValue();

    ConstantReader objectConstantReader = ConstantReader(object);
    if (!objectConstantReader.isLiteral) {
      throw ArgumentError('The instance argument should be a literal');
    }

    final String className = implementation?.name ?? object.type.name;
    final String typeParameters =
        abstraction == null ? '' : '<${abstraction.name}, $className>';

    final String nameArgument = name == null ? '' : ", name: '$name'";

    if (objectConstantReader.isNull) {
      // When object is null, we assume the developer used either
      // Register.singleton or Register.factory constructor.
      if (implementation == null) {
        throw ArgumentError.notNull('implementation');
      }

      final ClassElement implementationClass =
          implementation.element.library.getType(implementation.name);

      final bool oneTime =
          registerObject.getField('oneTime').toBoolValue() ?? false;
      final Map<DartType, String> resolvers =
          _computeResolvers(registerObject.getField('resolvers').toMapValue());

      final String oneTimeArgument = oneTime ? ', oneTime: true' : '';
      final String factoryParameters =
          _generateRegisterArguments(implementationClass, resolvers).join(', ');

      return Code(
          'container.registerFactory$typeParameters(() => $className($factoryParameters$nameArgument$oneTimeArgument));');
    } else {
      // When object is not null, we assume the developer used
      // the Register.instance constructor.
      final Object literal = objectConstantReader.literalValue;
      final String literalCode =
          objectConstantReader.isString ? "'$literal'" : literal.toString();
      return Code(
          'container.registerInstance$typeParameters($literalCode$nameArgument);');
    }
  }

  List<String> _generateRegisterArguments(
      ClassElement implementationClass, Map<DartType, String> resolvers) {
    return implementationClass.unnamedConstructor.parameters
        .map(
            (p) => _generateRegisterArgument(implementationClass, p, resolvers))
        .toList();
  }

  String _generateRegisterArgument(ClassElement implementationClass,
      ParameterElement parameter, Map<DartType, String> resolvers) {
    final String name = resolvers == null ? null : resolvers[parameter.type];
    final String nameArgument = name == null ? '' : "'$name'";
    return '${parameter.isNamed ? parameter.name + ': ' : ''}container.resolve<${parameter.type.name}>($nameArgument)';
  }

  Map<DartType, String> _computeResolvers(
      Map<DartObject, DartObject> resolvers) {
    return resolvers?.map((key, value) =>
        MapEntry<DartType, String>(key.toTypeValue(), value.toStringValue()));
  }
}
