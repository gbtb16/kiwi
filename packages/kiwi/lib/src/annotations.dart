import 'package:kiwi/kiwi.dart';

/// An annotation that generates code for registering factories
/// using the kiwi container.
class Register {
  /// Create an annotation that will generate a `registerFactory` method.
  const Register.factory(
    this.type, {
    this.name,
    this.from,
    this.resolvers,
    this.constructorName,
  }) : oneTime = null;

  /// Create an annotation that will generate a `registerSingleton` method.
  const Register.singleton(
    this.type, {
    this.name,
    this.from,
    this.resolvers,
    this.constructorName,
  }) : oneTime = true;

  /// The type to register.
  final Type type;

  /// The type to create when requesting [type].
  final Type? from;

  /// The name under which the factory will be registered
  ///
  /// You must provide the same name in [KiwiContainer.resolve]
  /// to get the same factory.
  final String? name;

  /// A map that give for a type, the name under which it should be resolved
  ///
  /// For example if you have registered a type T under the name
  /// 'myType', you have to specify it in this map in order
  /// to use it instead of the default value for the type T.
  final Map<Type, String>? resolvers;

  /// The name of the constructor to use inside the factory.
  final String? constructorName;

  /// Whether the factory has to be created only one time.
  final bool? oneTime;
}
