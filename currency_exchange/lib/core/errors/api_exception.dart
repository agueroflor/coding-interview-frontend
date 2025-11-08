class ApiException implements Exception {
  final String message;
  final ApiErrorType type;

  ApiException(this.message, this.type);

  @override
  String toString() => message;
}

enum ApiErrorType {
  network,
  timeout,
  noData,
  server,
  unknown,
}
