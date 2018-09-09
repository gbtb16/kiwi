import 'package:kiwi/kiwi.dart';

main() {
  Container container = Container();
  container.registerInstance(Logger());
  container.registerSingleton((c) => Logger(), name: 'logA');
  container.registerFactory((c) => ServiceA(c.resolve<Logger>('logA')));
}

class Service {}

class ServiceA extends Service {
  ServiceA(Logger logger);
}

class Logger {}
