import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publication.dart';

class OpenAlexService {

  Future<List<Publication>> searchPublications(
      String keyword) async {

    final url =
        "https://api.openalex.org/works?search=$keyword&per_page=20";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      List results = data["results"];

      return results
          .map(
            (item) => Publication.fromJson(item),
          )
          .toList();

    } else {
      throw Exception(
        "Failed to load publications",
      );
    }
  }
}