import 'service.dart';
import 'service_a.dart';

class ServiceB extends Service {
  final ServiceA serviceA;

  const ServiceB({required this.serviceA});
}
