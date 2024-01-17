import 'service.dart';
import 'service_a.dart';
import 'service_b.dart';

class ServiceC extends Service {
  ServiceC({required ServiceA serviceA, required ServiceB serviceB});

  ServiceC.other({required ServiceA serviceA});
}
