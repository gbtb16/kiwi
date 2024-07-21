import 'package:kiwi/src/model/exception/kiwi_error.dart';
import 'package:kiwi/src/model/exception/not_registered_error.dart';
import 'package:meta/meta.dart';

/// Signature for a builder which creates an object of type [T].
typedef FactoryBuilder<T> = T Function(KiwiContainer container);

/// Signature for the generic provider name.
typedef _ProviderName = String;

/// Signature for the generic provider value.
typedef _ProviderValue = Map<Type, _Provider<Object>>;

/// A simple service container.
class KiwiContainer {
  /// Creates a scoped container.
  ///
  /// If [parent] is set, the new scoped instance will include its providers.
  KiwiContainer.scoped({
    KiwiContainer? parent,
  }) : _providers = <_ProviderName?, _ProviderValue>{
          if (parent != null)
            ...parent._providers.map(
              // [Map.from] is needed to create a copy of value and not use its reference,
              // because if only value is passed, everything included in the parent will be
              // added to the new instance at any time, even after this scoped instance has been created.
              (key, value) => MapEntry(key, Map.from(value)),
            ),
        };

  static final KiwiContainer _instance = KiwiContainer.scoped();

  /// Always returns a singleton representing the only container to be alive.
  factory KiwiContainer() => _instance;

  /// Map of all instances and builders registered in the container.
  final Map<_ProviderName?, _ProviderValue> _providers;

  /// All providers registered in the container,
  /// including named our unnamed instances and builders.
  ///
  /// Instances and builders can be named or unnamed.
  ///
  /// Example:
  /// ```dart
  /// {
  ///   "int-instance": {int: 1},
  ///   null: {Character: Character('Anakin', 'Skywaker')},
  /// };
  /// ```
  Map<_ProviderName?, _ProviderValue> get providers => _providers;

  /// All named providers values registered in the container.
  ///
  /// Example:
  /// ```dart
  /// {
  ///   "int-instance": {int: 1},
  ///   "character-builder": {Character: Character('Anakin', 'Skywaker')},
  /// };
  /// ```
  Map<_ProviderName?, _ProviderValue> get namedProviders {
    return Map<_ProviderName?, _ProviderValue>.from(_providers)
      ..removeWhere((key, value) => key == null);
  }

  /// All unnamed providers values registered in the container.
  ///
  /// Example:
  /// ```dart
  /// {
  ///   null: {double: 2.0},
  ///   null: {Vehicle: Car('Chevrolet Opala SS')},
  /// };
  /// ```
  Map<_ProviderName?, _ProviderValue> get unnamedProviders {
    return Map<_ProviderName?, _ProviderValue>.from(_providers)
      ..removeWhere((key, value) => key != null);
  }

  /// Whether ignoring KiwiErrors in the following cases:
  /// * if you register the same type under the same name a second time.
  /// * if you try to resolve a type that was not previously registered.
  /// * if you try to unregister a type that was not previously registered.
  ///
  /// Defaults to false.
  bool silent = false;

  /// Registers an instance into the container.
  ///
  /// An instance of type [S] can be registered.
  ///
  /// If [name] is set, the instance will be registered under this name.
  /// To retrieve the same instance, the same name should be provided
  /// to [KiwiContainer.resolve].
  void registerInstance<S>(
    S instance, {
    String? name,
  }) {
    _setProvider(name, _Provider<S>.instance(instance));
  }

  /// Registers a factory into the container.
  ///
  /// A factory returning an object of type [S] can be registered.
  ///
  /// If [name] is set, the factory will be registered under this name.
  /// To retrieve the same factory, the same name should be provided
  /// to [KiwiContainer.resolve].
  void registerFactory<S>(
    FactoryBuilder<S> factory, {
    String? name,
  }) {
    _setProvider(name, _Provider<S>.factory(factory));
  }

  /// Registers a factory that will be called only only when
  /// accessing it for the first time, into the container.
  ///
  /// A factory returning an object of type [S] can be registered.
  ///
  /// If [name] is set, the factory will be registered under this name.
  /// To retrieve the same factory, the same name should be provided
  /// to [KiwiContainer.resolve].
  void registerSingleton<S>(
    FactoryBuilder<S> factory, {
    String? name,
  }) {
    _setProvider(name, _Provider<S>.singleton(factory));
  }

  /// Removes the entry previously registered for the type [T].
  ///
  /// If [name] is set, removes the one registered for that name.
  void unregister<T>([String? name]) {
    if (!silent && !(_providers[name]?.containsKey(T) ?? false)) {
      throw KiwiError(
          'Failed to unregister `$T`:\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }

    _providers[name]?.remove(T);
  }

  /// Attemps to resolve the type [T].
  ///
  /// If [name] is set, the instance or builder registered with this
  /// name will be get.
  ///
  /// See also:
  ///
  ///  * [KiwiContainer.registerFactory] for register a builder function.
  ///  * [KiwiContainer.registerInstance] for register an instance.
  T resolve<T>([String? name]) {
    final providers = _providers[name] ?? _ProviderValue.from({});

    if (!silent && !(providers.containsKey(T))) {
      throw NotRegisteredKiwiError(
          'Failed to resolve `$T`:\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }

    final value = providers[T]?.get(this);
    if (value == null) {
      throw NotRegisteredKiwiError(
          'Failed to resolve `$T`:\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }

    if (value is T) return value as T;

    throw NotRegisteredKiwiError(
        'Failed to resolve `$T`:\n\nValue was not registered as `$T`\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
  }

  /// Attemps to resolve the type [S] and tries to cast it to T.
  ///
  /// If [name] is set, the instance or builder registered with this
  /// name will be get.
  ///
  /// This method is only available for Testing.
  ///
  /// See also:
  ///
  ///  * [KiwiContainer.resolve] for resolving the object itself.
  ///  * [KiwiContainer.registerFactory] for register a builder function.
  ///  * [KiwiContainer.registerInstance] for register an instance.
  @visibleForTesting
  T? resolveAs<S, T extends S>([String? name]) {
    final object = resolve<S>(name);

    if (!silent && !(object is T)) {
      throw KiwiError(
          'Failed to resolve `$S` as `$T`:\n\nThe type `$S` as `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }

    if (object == null) return null;
    if (object is T) return object as T;

    return null;
  }

  T call<T>([String? name]) => resolve<T>(name);

  /// Returns if an instance or builder of type [T] is registered.
  ///
  /// If an instance or builder of type [T] is registered with a name,
  /// and the name is not passed to [isRegistered], returns false.
  bool isRegistered<T>({String? name}) {
    return (_providers.containsKey(name) && _providers[name]!.containsKey(T));
  }

  /// Removes all instances and builders from the container.
  ///
  /// After this, the container is empty.
  void clear() {
    _providers.clear();
  }

  void _setProvider<T>(String? name, _Provider<T> provider) {
    if (!silent && isRegistered<T>(name: name)) {
      throw KiwiError(
          'The type `$T` was already registered${name == null ? '' : ' for the name `$name`'}');
    }

    _providers.putIfAbsent(name, () => _ProviderValue.from({}))[T] =
        provider as _Provider<Object>;
  }
}

class _Provider<T> {
  final FactoryBuilder<T>? _instanceBuilder;

  T? object;
  bool _oneTime = false;

  _Provider.instance(this.object)
      : _instanceBuilder = null,
        _oneTime = false;

  _Provider.factory(this._instanceBuilder) : _oneTime = false;

  _Provider.singleton(this._instanceBuilder) : _oneTime = true;

  T? get(KiwiContainer container) {
    final instanceBuilder = _instanceBuilder;

    if (_oneTime && instanceBuilder != null) {
      object = instanceBuilder(container);
      _oneTime = false;
    }

    if (object != null) {
      return object;
    }

    if (instanceBuilder != null) {
      return instanceBuilder(container);
    }

    return null;
  }

  @override
  String toString() {
    return '''
      _Provider(
        _instanceBuilder: $_instanceBuilder,
        object: $object,
        _oneTime: $_oneTime,
      );
    ''';
  }
}
