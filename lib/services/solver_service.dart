
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
    debugPrint('SOLVER STATUS: ${response.statusCode}');
debugPrint('SOLVER RESPONSE: ${response.body}');

    final Map<String, dynamic> json;

    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception(
        'Invalid response from solver server (${response.statusCode}).',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        json['error']?.toString() ?? 'Failed to solve cube.',
      );
    }

    if (json['solution'] is! String) {
      throw Exception('Invalid solution received from server.');
    }

    final solution = (json['solution'] as String).trim();

    return solution.isEmpty
        ? []
        : solution.split(RegExp(r'\s+'));
  }
}
