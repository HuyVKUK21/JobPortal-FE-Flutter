import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile.dart';
import '../services/api_service.dart';

// Profile State
class ProfileState {
  final ProfileResponse? profile;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    ProfileResponse? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Profile Notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final ApiService _apiService;

  ProfileNotifier(this._apiService) : super(ProfileState());

  /// Get current user's profile
  Future<void> getMyProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getMyProfile();

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          profile: response.data,
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

  /// Update current user's profile
  Future<void> updateMyProfile(UpdateProfileRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.updateMyProfile(request);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          profile: response.data,
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

  /// Clear profile data (e.g., on logout)
  void clearProfile() {
    state = ProfileState();
  }
}

// Providers
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ApiService());
});

// Convenience providers for accessing specific parts of state
final currentProfileProvider = Provider<ProfileResponse?>((ref) {
  return ref.watch(profileProvider).profile;
});

final profileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isLoading;
});

final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileProvider).error;
});
