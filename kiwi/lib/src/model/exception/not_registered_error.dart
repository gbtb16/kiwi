import 'package:kiwi/src/model/exception/kiwi_error.dart';

class NotRegisteredKiwiError extends KiwiError {
  NotRegisteredKiwiError(String message) : super(message);

  @override
  String toString() {
    return 'Not Registered KiwiError:\n\n\n$message\n\n\n';
  }
}
