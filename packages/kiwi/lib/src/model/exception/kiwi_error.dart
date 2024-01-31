class KiwiError extends Error {
  final String message;

  KiwiError(this.message);

  @override
  String toString() {
    return 'KiwiError:\n\n\n$message\n\n\n';
  }
}
