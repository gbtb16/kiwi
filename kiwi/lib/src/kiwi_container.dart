import 'package:kiwi/src/model/exception/kiwi_error.dart';
import 'package:kiwi/src/model/exception/not_registered_error.dart';
import 'package:meta/meta.dart';

/// Signature for a builder which creates an object of type [T].
typedef T Factory<T>(KiwiContainer container);

/// A simple service container.
class KiwiContainer {
  /// Creates a scoped container.
  KiwiContainer.scoped()
      : _namedProviders = Map<String?, Map<Type, _Provider<Object?>>>();

  static final KiwiContainer _instance = KiwiContainer.scoped();

  /// Always returns a singleton representing the only container to be alive.
  factory KiwiContainer() => _instance;

  final Map<String?, Map<Type, _Provider<Object?>>> _namedProviders;

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
    Factory<S> factory, {
    String? name,
    bool includeNull = false
  }) {
    _setProvider(name, _Provider<S>.factory(factory));
    if(includeNull){
      _setProvider(name, _Provider<S?>.factory(factory));
    }
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
    Factory<S> factory, {
    String? name,
  }) {
    _setProvider(name, _Provider<S>.singleton(factory));
  }

  /// Removes the entry previously registered for the type [T].
  ///
  /// If [name] is set, removes the one registered for that name.
  void unregister<T>([String? name]) {
    if (!silent && !(_namedProviders[name]?.containsKey(T) ?? false)) {
      throw KiwiError(
          'Failed to unregister `$T`:\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }
    _namedProviders[name]?.remove(T);
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
    final providers = _namedProviders[name] ?? Map<Type, _Provider<Object>>();
    if (!silent && !(providers.containsKey(T))) {
      throw NotRegisteredKiwiError(
          'Failed to resolve `$T`:\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }

    final value = providers[T]?.get(this);
    if (value == null && !silent) {
      throw NotRegisteredKiwiError(
          'Failed to resolve `$T`:\n\nThe type `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }
    if (value is T) return value;
    if(silent) return null as T;
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
    final obj = resolve<S>(name);
    if (!silent && !(obj is T)) {
      throw KiwiError(
          'Failed to resolve `$S` as `$T`:\n\nThe type `$S` as `$T` was not registered${name == null ? '' : ' for the name `$name`'}\n\nMake sure `$T` is added to your KiwiContainer and rerun build_runner build\n(If you are using the kiwi_generator)\n\nWhen using Flutter, most of the time a hot restart is required to setup the KiwiContainer again.');
    }
    if (obj == null) return null;
    if (obj is T) return obj as T;
    return null;
  }

  T call<T>([String? name]) => resolve<T>(name);

  /// Removes all instances and builders from the container.
  ///
  /// After this, the container is empty.
  void clear() {
    _namedProviders.clear();
  }

  void _setProvider<T>(String? name, _Provider<T> provider) {
    final nameProviders = _namedProviders;
    if (!silent &&
        (nameProviders.containsKey(name) &&
            nameProviders[name]!.containsKey(T))) {
      throw KiwiError(
          'The type `$T` was already registered${name == null ? '' : ' for the name `$name`'}');
    }
    _namedProviders.putIfAbsent(name, () => Map<Type, _Provider<Object?>>())[T] =
        provider as _Provider<Object?>;
  }
}

class _Provider<T> {
  _Provider.instance(this.object)
      : _instanceBuilder = null,
        _oneTime = false;

  _Provider.factory(this._instanceBuilder) : _oneTime = false;

  _Provider.singleton(this._instanceBuilder) : _oneTime = true;

  final Factory<T>? _instanceBuilder;
  T? object;
  bool _oneTime = false;

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
}
