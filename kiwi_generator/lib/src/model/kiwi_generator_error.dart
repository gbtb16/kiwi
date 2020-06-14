class KiwiGeneratorError extends Error {
  final String message;
  final Error error;

  KiwiGeneratorError(this.message, {this.error});

  @override
  String toString() {
    var toString = '\nKiwiGeneratorError\n\n$message\n\n';
    if (error != null) {
      toString +=
          '============\n${error.toString()}\n${error.stackTrace}\n============\n\n';
    }
    return toString;
  }
}
