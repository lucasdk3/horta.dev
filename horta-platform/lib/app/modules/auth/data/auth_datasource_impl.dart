import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  GoogleSignInAccount? _currentUser;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  GoogleSignInAccount? get currentUser => _currentUser;
  String? get currentUserEmail => _currentUser?.email;

  AuthService() {
    _init();
  }

  Future<void> _init() async {
    if (!kIsWeb) {
      await GoogleSignIn.instance.initialize();
    }
    await _checkStoredToken();
  }

  Future<void> _checkStoredToken() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      _currentUser = account;
      final auth = account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) throw Exception('Failed to retrieve Google ID Token');

      final response =
          await _dio.post('/auth/google', data: {'idToken': idToken});

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _storage.write(
            key: 'jwt_token', value: response.data['token'] as String);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      throw Exception('Failed to authenticate with backend');
    } on UnimplementedError {
      debugPrint(
          'Google Sign-In: authenticate() not supported on web, use renderButton.');
      return false;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _storage.delete(key: 'jwt_token');
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  Future<String?> getToken() => _storage.read(key: 'jwt_token');
}
