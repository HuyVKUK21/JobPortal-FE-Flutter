import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_state.dart';

/// Temporary auth provider using ChangeNotifier
/// TODO: Replace with Riverpod StateNotifier when integrating backend
class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial();

  AuthState get state => _state;

  bool get isAuthenticated => _state.isAuthenticated;
  bool get isLoading => _state.isLoading;

  /// Mock login - replace with actual API call
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _state = AuthState.loading();
    notifyListeners();

    try {
      // TODO: Call API here
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Mock success - replace with actual user data from API
      // final user = await authRepository.login(email, password, rememberMe);
      // _state = AuthState.authenticated(user);
      
      _state = AuthState.unauthenticated(); // Keep unauthenticated for now
      notifyListeners();
    } catch (e) {
      _state = AuthState.unauthenticated();
      notifyListeners();
      rethrow;
    }
  }

  /// Mock register - replace with actual API call
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _state = AuthState.loading();
    notifyListeners();

    try {
      // TODO: Call API here
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Mock success
      _state = AuthState.unauthenticated();
      notifyListeners();
    } catch (e) {
      _state = AuthState.unauthenticated();
      notifyListeners();
      rethrow;
    }
  }

  /// Mock logout
  Future<void> logout() async {
    _state = AuthState.unauthenticated();
    notifyListeners();
  }

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    // TODO: Check local storage or token
    _state = AuthState.unauthenticated();
    notifyListeners();
  }
}


