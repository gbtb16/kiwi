class KiwiGeneratorError extends Error {
  final String message;
  final Error? error;

  KiwiGeneratorError(
    this.message, {
    this.error,
  });

  @override
  String toString() {
    var toString = '\nKiwiGeneratorError\n\n$message\n\n';
    final internalError = error;
    if (internalError != null) {
      toString += '============\n${internalError.toString()}\n${internalError.stackTrace}\n============\n\n';
    }
    return toString;
  }
}
