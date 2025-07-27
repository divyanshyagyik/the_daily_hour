import 'package:intl/intl.dart';

class NewsArticle {
  final String title;
  final String? description;
  final String? content;
  final String? imageUrl;
  final String source;
  final DateTime pubDate;
  final String url;

  NewsArticle({
    required this.title,
    required this.description,
    this.content,
    required this.imageUrl,
    required this.source,
    required this.pubDate,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      content: json['content'],
      imageUrl: json['image_url'],
      source: json['source_id'] ?? 'Unknown',
      pubDate: _parseDate(json['pubDate']),
      url: json['link'] ?? '',
    );
  }

  static DateTime _parseDate(dynamic dateString) {
    try {
      return DateTime.parse(dateString ?? DateTime.now().toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  String get formattedDate {
    return DateFormat('MMM d, y • h:mm a').format(pubDate);
  }

  String get displayContent {
    return content ?? description ?? 'No content available';
  }
}