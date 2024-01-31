class Model {
  const Model(
    this.brand,
    this.name,
  );
  final String name;
  final String brand;

  @override
  String toString() => '$name by $brand';
}
