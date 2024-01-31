extension ListExtension<T> on List<T> {
  T? singleOrNullWhere(bool test(T element)) {
    late T result;
    bool foundMatching = false;
    for (T element in this) {
      if (test(element)) {
        if (foundMatching) {
          throw Exception('No many results');
        }
        result = element;
        foundMatching = true;
      }
    }
    if (foundMatching) return result;
    return null;
  }
}
