import 'package:flutter_application_1/features/auth/domain/entities/user_entity.dart';

/// Abstract repository interface for authentication
/// This will be implemented in the data layer
abstract class AuthRepository {
  /// Login with email and password
  Future<UserEntity> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Register a new user
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  /// Logout current user
  Future<void> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Login with Google
  Future<UserEntity> loginWithGoogle();

  /// Login with Facebook
  Future<UserEntity> loginWithFacebook();

  /// Request password reset
  Future<void> requestPasswordReset(String email);
}


