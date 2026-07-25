class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://backend-siakad.synectra.xyz/api';

  static String resolveImageUrl(String url) {
    if (url.isEmpty) return '';
    // If it's a relative path, prepend it with the base host
    if (!url.startsWith('http')) {
      final baseUri = Uri.parse(baseUrl);
      final normalized = url.startsWith('/') ? url : '/$url';
      return '${baseUri.scheme}://${baseUri.host}$normalized';
    }
    // If it's an absolute URL pointing to localhost/127.0.0.1, rewrite it to use baseUrl's host
    if (url.contains('localhost:8000') || url.contains('127.0.0.1:8000')) {
      final baseUri = Uri.parse(baseUrl);
      final path = Uri.parse(url).path; // e.g. /storage/uploads/...
      return '${baseUri.scheme}://${baseUri.host}$path';
    }
    return url;
  }
}
