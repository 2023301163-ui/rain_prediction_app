import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/analytics_data.dart';

class AnalyticsService {
  AnalyticsService({String? baseUrl}) : _baseUrl = baseUrl ?? 'http://localhost:3000/api';

  final String _baseUrl;

  Future<AnalyticsData> fetchAnalytics() async {
    final uri = Uri.parse('$_baseUrl/analytics');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load analytics data (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? body;
    return AnalyticsData.fromJson(data);
  }
}
