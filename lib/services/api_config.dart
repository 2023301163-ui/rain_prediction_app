import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    final host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
    return 'http://$host:3000/api';
  }
}