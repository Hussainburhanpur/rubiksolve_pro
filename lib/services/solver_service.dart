import 'dart:convert';

import 'package:http/http.dart' as http;

class SolverService {
  final String baseUrl;

  SolverService({
    required this.baseUrl,
  });

  Future<List<String>> solve(String cube) async {
    final response = await http.post(
      Uri.parse('$baseUrl/solve'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'cube': cube,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to solve cube');
    }

    final json = jsonDecode(response.body);

    final solution = json['solution'] as String;

    return solution.split(' ');
  }
}