import 'package:flutter/foundation.dart';
import 'package:pms/features/authentication/data/repositories/auth_repository.dart';
import 'package:pms/shared/models/user_model.dart';
import 'package:pms/core/network/api_error_handler.dart';

class AuthProvider extends ChangeNotifier {
  AuthRepository _authRepository;
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;

  AuthProvider(this._authRepository);

  void updateRepo(AuthRepository repo) {
    _authRepository = repo;
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set remember me
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      _currentUser = await _authRepository.login(email, password);
      _isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(ApiErrorHandler.handleErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authRepository.logout();
      _currentUser = null;
      _isAuthenticated = false;
      _rememberMe = false;
      _setLoading(false);
    } catch (e) {
      _setError(ApiErrorHandler.handleErrorMessage(e));
      _setLoading(false);
    }
  }

  // Register method
  // For now keeping it mocked or you can add to repository
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      _currentUser = await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      _isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(ApiErrorHandler.handleErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  // Forgot password method
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(seconds: 2));
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(ApiErrorHandler.handleErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    _setLoading(true);

    try {
      // In a real app, check token validity
      await Future.delayed(const Duration(seconds: 1));
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }
}
