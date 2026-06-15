import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publication.dart';

class OpenAlexService {

  Future<List<Publication>> searchPublications(String keyword) async {
    final uri = Uri.https('api.openalex.org', '/works', {
      'search': keyword,
      'per_page': '20',
      'mailto': 'student@fpt.edu.vn', // Polite Pool
    });

    int maxRetries = 3;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          List results = data["results"];

          return results.map((item) => Publication.fromJson(item)).toList();
        } else if (response.statusCode == 503 || response.statusCode == 429) {
          // If server is unavailable, wait and retry
          if (attempt < maxRetries - 1) {
            await Future.delayed(Duration(seconds: 1 + attempt));
            continue;
          }
          throw Exception("Server OpenAlex đang quá tải (Lỗi ${response.statusCode}). Vui lòng thử lại sau.");
        } else {
          throw Exception("Lỗi tải dữ liệu. Status: ${response.statusCode}, Body: ${response.body}");
        }
      } catch (e) {
        if (attempt == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: 1 + attempt));
      }
    }
    return [];
  }
}