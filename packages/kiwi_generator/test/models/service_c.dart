import 'service.dart';
import 'service_a.dart';

class ServiceC extends Service {
  final ServiceA serviceA;

  ServiceC({required this.serviceA});
  ServiceC.other({required this.serviceA});
}
