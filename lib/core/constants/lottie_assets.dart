class LottieAssets {
  LottieAssets._();

  // Local animation paths
  static const String loading = 'lib/core/animations/loading_animation.json';
  static const String success = 'lib/core/animations/success_animation.json';
  static const String noResultFound = 'lib/core/animations/no_result_found_animation.json';
  static const String error404 = 'lib/core/animations/404_error_animation.json';
  static const String noInternet = 'lib/core/animations/no_internet.json';
  
  // Legacy names for backward compatibility
  static const String emptySearch = noResultFound;
  static const String successCheck = success;
  static const String loadingSpinner = loading;
}
