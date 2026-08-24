import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/rain_data.dart';

class RainService {
  RainService({String? baseUrl}) : _baseUrl = baseUrl ?? 'http://localhost:3000/api';

  final String _baseUrl;

  Future<RainData> fetchLatestData() async {
    final uri = Uri.parse('$_baseUrl/rain/latest');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data from backend (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? body;

    return RainData.fromJson(data);
  }
}
