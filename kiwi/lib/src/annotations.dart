class Register {
  const Register.factory(
    this.implementation, {
    this.name,
    this.as,
    this.resolvers,
    this.constructorName,
  })  : assert(implementation != null),
        oneTime = null;

  const Register.singleton(
    this.implementation, {
    this.name,
    this.as,
    this.resolvers,
    this.constructorName,
  })  : assert(implementation != null),
        oneTime = true;

  final Type implementation;
  final Type as;
  final String name;
  final Map<Type, String> resolvers;
  final bool oneTime;
  final String constructorName;
}
