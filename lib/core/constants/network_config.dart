import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkConfig {
  // Base URLs cho các platform khác nhau
  static const String _localhost = 'http://192.168.1.12:8080/api';
  static const String _androidEmulator = 'http://192.168.1.12:8080/api';
  
  // TODO: Thay đổi IP này theo máy của bạn
  // Chạy 'ipconfig' trên Windows để tìm IPv4 Address
  // Ví dụ: 192.168.1.100, 192.168.0.105, etc.
  static const String _networkIP = 'http://192.168.1.31:8080/api';
  
  // Environment variable để override IP (optional)
  static const String? _envNetworkIP = String.fromEnvironment('NETWORK_IP');
  
  // Lấy base URL phù hợp với platform
  static String get baseUrl {
    // Use environment variable if provided
    if (_envNetworkIP != null && _envNetworkIP!.isNotEmpty) {
      if (kDebugMode) print('🌐 Using environment network IP: $_envNetworkIP');
      return _envNetworkIP!;
    }
    
    if (Platform.isAndroid) {
      // Check if running on real device or emulator
      // Real devices need the network IP
      // Emulators use 10.0.2.2
      
      // For now, we'll use emulator IP by default
      // To use real device, change this to return _networkIP
      if (kDebugMode) print('🌐 Android detected - using emulator IP');
      return _androidEmulator;
      
      // Uncomment below and comment above to use real device
      // if (kDebugMode) print('🌐 Android detected - using network IP');
      // return _networkIP;
    } else if (Platform.isIOS) {
      // iOS simulator có thể sử dụng localhost
      return _localhost;
    } else {
      // Web và desktop sử dụng localhost
      return _localhost;
    }
  }
  
  // Debug method để test các URLs
  static void printNetworkInfo() {
    // Debug logging - remove in production
    if (kDebugMode) {
      print('🌐 Network Configuration:');
      print('Platform: ${Platform.operatingSystem}');
      print('Base URL: $baseUrl');
      print('Localhost: $_localhost');
      print('Android Emulator: $_androidEmulator');
      print('Network IP: $_networkIP');
    }
  }
  
  // Test connectivity
  static Future<bool> testConnectivity() async {
    try {
      final client = HttpClient();
      final uri = Uri.parse(baseUrl.replaceAll('/api', ''));
      final request = await client.getUrl(uri);
      final response = await request.close();
      
      if (kDebugMode) print('✅ Network test successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print('❌ Network test failed: $e');
      return false;
    }
  }
}





