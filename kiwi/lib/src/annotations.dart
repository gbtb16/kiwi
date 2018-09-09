/// An annotation that generates code for registering factories
/// using the kiwi container.
class Register {
  /// Create an annotation that will generate a `registerFactory` method.
  const Register.factory(
    this.concrete, {
    this.name,
    this.as,
    this.resolvers,
    this.constructorName,
  })  : assert(concrete != null),
        oneTime = null;

  /// Create an annotation that will generate a `registerSingleton` method.
  const Register.singleton(
    this.concrete, {
    this.name,
    this.as,
    this.resolvers,
    this.constructorName,
  })  : assert(concrete != null),
        oneTime = true;

  /// The concrete type.
  final Type concrete;

  /// The abstract type.
  ///
  /// If you don't define an abstract type, the
  /// factory will be registered under the concrete type.
  final Type as;

  /// The name under which the factory will be registered
  ///
  /// You must provide the same name in [Container.resolve]
  /// to get the same factory.
  final String name;

  /// A map that give for a type, the name under which it should be resolved
  ///
  /// For example if you have registered a type T under the name
  /// 'myType', you have to specify it in this map in order
  /// to use it instead of the default value for the type T.
  final Map<Type, String> resolvers;

  /// The name of the constructor to use inside the factory.
  final String constructorName;

  /// Whether the factory has to be created only one time.
  final bool oneTime;
}
