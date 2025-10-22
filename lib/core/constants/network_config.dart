import 'dart:io';

class NetworkConfig {
  // Base URLs cho các platform khác nhau
  static const String _localhost = 'http://localhost:8080/api';
  static const String _androidEmulator = 'http://10.0.2.2:8080/api';
  static const String _networkIP = 'http://192.168.1.100:8080/api'; // Thay đổi IP này theo máy của bạn
  
  // Lấy base URL phù hợp với platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator sử dụng 10.0.2.2
      // Android device sử dụng IP thực của máy host
      return _androidEmulator;
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
    print('🌐 Network Configuration:');
    print('Platform: ${Platform.operatingSystem}');
    print('Base URL: $baseUrl');
    print('Localhost: $_localhost');
    print('Android Emulator: $_androidEmulator');
    print('Network IP: $_networkIP');
  }
  
  // Test connectivity
  static Future<bool> testConnectivity() async {
    try {
      final client = HttpClient();
      final uri = Uri.parse(baseUrl.replaceAll('/api', ''));
      final request = await client.getUrl(uri);
      final response = await request.close();
      
      print('✅ Network test successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Network test failed: $e');
      return false;
    }
  }
}





