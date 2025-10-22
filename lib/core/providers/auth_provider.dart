import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';
import '../services/token_storage_service.dart';

// Auth State
class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null && token != null;
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final ApiService _apiService = ApiService();

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.login(request);

      if (response.isSuccess && response.data != null) {
        // Save user data to storage
        await TokenStorageService.saveUserData({
          'userId': response.data!.user.userId,
          'email': response.data!.user.email,
          'firstName': response.data!.user.firstName,
          'lastName': response.data!.user.lastName,
          'userType': response.data!.user.userType,
        });
        
        state = state.copyWith(
          user: response.data!.user,
          token: response.data!.token,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> registerEmployer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String companyName,
    required String companyIndustry,
    required String companyLocation,
    required String companyWebsite,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterEmployerRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        companyName: companyName,
        companyIndustry: companyIndustry,
        companyLocation: companyLocation,
        companyWebsite: companyWebsite,
      );

      final response = await _apiService.registerEmployer(request);

      if (response.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> registerJobSeeker({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    String? portfolioLink,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterJobSeekerRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        portfolioLink: portfolioLink,
      );

      final response = await _apiService.registerJobSeeker(request);

      if (response.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  void logout() {
    _apiService.clearToken();
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Initialize auth state from storage
  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Initialize token from storage
      await _apiService.initializeToken();
      
      // Check if user is logged in
      final isLoggedIn = await TokenStorageService.isLoggedIn();
      if (isLoggedIn) {
        final userData = await TokenStorageService.getUserData();
        if (userData != null) {
          // Create user object from stored data
          final user = User(
            userId: userData['userId'] ?? 0,
            email: userData['email'] ?? '',
            firstName: userData['firstName'] ?? '',
            lastName: userData['lastName'] ?? '',
            userType: userData['userType'] ?? 'jobseeker',
          );
          
          state = state.copyWith(
            user: user,
            token: _apiService.token,
            isLoading: false,
            error: null,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize auth: $e',
      );
    }
  }
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});





