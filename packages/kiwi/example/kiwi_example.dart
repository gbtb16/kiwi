import 'package:kiwi/kiwi.dart';

main() {
  KiwiContainer container = KiwiContainer();

  container.registerInstance(Logger());
  container.registerSingleton((c) => Logger(), name: 'namedLogger');
  container.registerFactory(
      (c) => ServiceA(logger: c.resolve<Logger>('namedLogger')));

  final comumLogger = container.resolve<Logger>();
  final namedLogger = container.resolve<Logger>('namedLogger');
  final serviceA = container.resolve<ServiceA>();

  print(comumLogger.toString()); // Hey, I'm a logger!
  print(namedLogger.toString()); // Hey, I'm a logger!
  print(serviceA.toString()); // Hey, I'm a service A!
}

class Service {
  const Service();

  @override
  String toString() {
    return 'Hey, I\'m a service!';
  }
}

class ServiceA extends Service {
  final Logger logger;

  const ServiceA({required this.logger});

  @override
  String toString() {
    return 'Hey, I\'m a service A!';
  }
}

class Logger {
  const Logger();

  @override
  String toString() {
    return 'Hey, I\'m a logger!';
  }
}
