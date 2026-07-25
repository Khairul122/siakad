class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? fieldErrors;

  const ApiException(this.message, {this.statusCode, this.fieldErrors});

  @override
  String toString() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final details = fieldErrors!.values.expand((v) => v is List ? v : [v]).join(', ');
      if (details.isNotEmpty) {
        return '$message: $details';
      }
    }
    return message;
  }
}
