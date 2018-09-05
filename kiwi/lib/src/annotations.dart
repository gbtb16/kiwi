class Register {
  const Register.instance(
    this.object, {
    this.name,
    this.as,
  })  : assert(object != null),
        implementation = null,
        resolvers = null,
        oneTime = null;

  const Register.factory(
    this.implementation, {
    this.name,
    this.as,
    this.resolvers,
  })  : assert(implementation != null),
        object = null,
        oneTime = null;

  const Register.singleton(
    this.implementation, {
    this.name,
    this.as,
    this.resolvers,
  })  : assert(implementation != null),
        object = null,
        oneTime = true;

  final Object object;
  final Type implementation;
  final Type as;
  final String name;
  final Map<Type, String> resolvers;
  final bool oneTime;
}
