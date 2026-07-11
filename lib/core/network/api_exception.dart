class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? fieldErrors;

  const ApiException(this.message, {this.statusCode, this.fieldErrors});

  @override
  String toString() => message;
}
