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
    final injectors = library.classElements
        .where((c) =>
            c.isAbstract &&
            c.methods
                .where((m) => m.isAbstract)
                .every((m) => _isRegisterMethod(m)))
        .toList();

    if (injectors.isEmpty) {
      return null;
    }

    final file = Library((lb) => lb
      ..body.addAll(
          injectors.map((i) => _generateInjector(i, library, buildStep))));

    final DartEmitter emitter = DartEmitter(Allocator());
    return DartFormatter().format('${file.accept(emitter)}');
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
        .where((m) => m.isAbstract && _isRegisterMethod(m))
        .map((m) => _generateInjectorMethod(m))
        .toList();
  }

  Method _generateInjectorMethod(MethodElement method) {
    return Method.returnsVoid((mb) => mb
      ..name = method.name
      ..body = Block((bb) => bb
        ..statements.add(Code('final Container container = Container();'))
        ..statements.addAll(_generateRegisters(method))));
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

    final String className = concreteType.name;
    final String typeParameters =
        concrete == null ? '' : '<${type.name}, $className>';

    final String nameArgument = name == null ? '' : ", name: '$name'";
    final String constructorName =
        registerObject.getField('constructorName').toStringValue();
    final String constructorNameArgument =
        constructorName == null ? '' : '.$constructorName';

    final ClassElement clazz = concreteType.element.library.getType(className);
    if (clazz == null) {
      throw '$className not found';
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
      throw ArgumentError(
        'the constructor ${clazz.name}.$constructorName does not exist',
      );
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
    return '${parameter.isNamed ? parameter.name + ': ' : ''}c<${parameter.type.name}>($nameArgument)';
  }

  Map<DartType, String> _computeResolvers(
    Map<DartObject, DartObject> resolvers,
  ) {
    return resolvers?.map((key, value) =>
        MapEntry<DartType, String>(key.toTypeValue(), value.toStringValue()));
  }
}
