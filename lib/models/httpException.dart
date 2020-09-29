class HttpException implements Exception {
  // All Dart classes automatically extends 'Object' class
  // 'toString()' is available in all classes
  // 'toString()' returns the instance of HttpException
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    /* return super.toString(); // Instance of HttpException */
  }
}
