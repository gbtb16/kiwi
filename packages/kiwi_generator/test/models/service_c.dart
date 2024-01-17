import 'service.dart';
import 'service_a.dart';
import 'service_b.dart';

class ServiceC extends Service {
  final ServiceA serviceA;
  final ServiceB? serviceB;

  ServiceC({required this.serviceA, required this.serviceB});
  ServiceC.other({required this.serviceA, this.serviceB});
}
