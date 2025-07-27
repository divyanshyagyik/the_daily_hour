import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'news_model.dart';


class NewsService {
  static final String apiKey = dotenv.env['API_KEY'] ?? '';
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static const int _maxFreeRequests = 200;
  int _requestCount = 0;

  Future<List<NewsArticle>> fetchNews({
    String? keyword,
    String? category,
  }) async {
    if (_requestCount >= _maxFreeRequests) {
      throw Exception('Daily free limit reached ($_maxFreeRequests requests)');
    }

    final url = Uri.parse(
        '$baseUrl?apikey=$apiKey'
            '&language=en'
            '${keyword != null ? '&q=${Uri.encodeComponent(keyword)}' : ''}'
            '${category != null ? '&category=$category' : ''}'

            '&size=10'
    );

    final response = await http.get(url);
    _requestCount++;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => NewsArticle.fromJson(json))
          .toList();
    } else if (response.statusCode == 402) {
      throw Exception('Free tier limit exceeded');
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}