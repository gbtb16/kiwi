import 'service.dart';
import 'service_a.dart';
import 'service_b.dart';

class ServiceC extends Service {
  const ServiceC(ServiceA serviceA, ServiceB serviceB);

  const ServiceC.other(ServiceA serviceA);
}
