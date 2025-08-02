import 'dart:convert';
import 'package:http/http.dart' as http;

class LogService {
  static const String baseUrl = 'http://localhost:5000/api';

  Future<List<String>> getDrowsinessLogs() async {
    final response = await http.get(Uri.parse('$baseUrl/drowsiness_logs'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body)['logs']);
    } else {
      throw Exception('Failed to load drowsiness logs');
    }
  }

  Future<List<String>> getYawningLogs() async {
    final response = await http.get(Uri.parse('$baseUrl/yawning_logs'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body)['logs']);
    } else {
      throw Exception('Failed to load yawning logs');
    }
  }

  Future<String> getVideoLogUrl() async {
    return '$baseUrl/video_log';
  }
}
