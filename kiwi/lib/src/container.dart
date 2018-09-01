/// Signature for a factory which creates an object of type [T].
typedef T Builder<T>(Container container);

/// A simple dependency container.
class Container {
  Container._() : _namedProviders = Map<String, Map<Type, _Provider<Object>>>();

  static final Container _instance = new Container._();

  /// Always returns a singleton representing the only container to be alive.
  factory Container() => _instance;

  final Map<String, Map<Type, _Provider<Object>>> _namedProviders;

  /// Registers an instance into the container.
  ///
  /// An instance of type [T] can be registered with a
  /// supertype [S] if specified.
  ///
  /// If [name] is set, the instance will be registered under this name.
  /// To retrieve the same instance, the same name should be provided
  /// to [Container.get].
  void registerInstance<S, T extends S>(
    S instance, {
    String name,
  }) {
    _setProvider(name, _Provider<S>.singleton(instance));
  }

  /// Registers a builder into the container.
  ///
  /// A builder returning an object of type [T] can be registered with a
  /// supertype [S] if specified.
  ///
  /// If [name] is set, the builder will be registered under this name.
  /// To retrieve the same builder, the same name should be provided
  /// to [Container.get].
  ///
  /// If [oneTime] is set to `true`, then the builder will be called only when
  /// accessing it for the first time.
  void registerBuilder<S, T extends S>(
    Builder<S> builder, {
    String name,
    bool oneTime = false,
  }) {
    _setProvider(name, _Provider<S>.builder(builder, oneTime));
  }

  /// Removes the entry previously registered for the type [T].
  ///
  /// If [name] is set, removes the one registered for that name.
  void unregister<T>({String name}) {
    _namedProviders[name]?.remove(T);
  }

  /// Gets an object registered under the type [T].
  ///
  /// If [name] is set, the instance or builder registered with this
  /// name will be get.
  ///
  /// See also:
  ///
  ///  * [Container.registerBuilder] for register a builder function.
  ///  * [Container.registerInstance] for register an instance.
  T get<T>([String name]) {
    Map<Type, _Provider<Object>> providers = _namedProviders[name];

    if (providers == null) {
      return null;
    }

    return providers[T]?.get(this);
  }

  /// Removes all instances and builders from the container.
  ///
  /// After this, the container is empty.
  void clear() {
    _namedProviders.clear();
  }

  void _setProvider<T>(String name, _Provider<T> provider) => _namedProviders
      .putIfAbsent(name, () => Map<Type, _Provider<Object>>())[T] = provider;
}

class _Provider<T> {
  _Provider.singleton(this.instance) : instanceBuilder = null;

  _Provider.builder(this.instanceBuilder, this.oneTime);

  final Builder<T> instanceBuilder;
  T instance;
  bool oneTime = false;

  T get(Container container) {
    if (oneTime && instanceBuilder != null) {
      instance = instanceBuilder(container);
      oneTime = false;
    }

    if (instance != null) {
      return instance;
    }

    if (instanceBuilder != null) {
      return instanceBuilder(container);
    }

    return null;
  }
}
