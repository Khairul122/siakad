import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  SessionService._internal();

  static final SessionService instance = SessionService._internal();

  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _uidKey = 'auth_uid';

  String? _token;
  String? _uid;

  String? get token => _token;
  String? get uid => _uid;
  bool get isLoggedIn => _token != null && _uid != null;

  Future<void> load() async {
    _token = await _storage.read(key: _tokenKey);
    _uid = await _storage.read(key: _uidKey);
  }

  Future<void> save({required String token, required String uid}) async {
    _token = token;
    _uid = uid;
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _uidKey, value: uid);
  }

  Future<void> clear() async {
    _token = null;
    _uid = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _uidKey);
  }
}
