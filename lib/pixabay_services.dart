import 'dart:convert';
import 'package:http/http.dart' as http;

class PixabayAPI {
  // Using your provided API key (not recommended for production)
  final String apiKey = '43407054-0723966d94fd9f94a032cc78c';
  final String baseUrl = 'https://pixabay.com/api/';

  Future<List<dynamic>> fetchImages() async {
    final response = await http.get(Uri.parse('$baseUrl?key=$apiKey&image_type=photo'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['hits'];
    } else {
      throw Exception('Failed to load images');
    }
  }
}