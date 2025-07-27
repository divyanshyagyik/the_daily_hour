import 'package:flutter/material.dart';
import 'package:untitled/model/news_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.source),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _launchOriginalArticle(article.url, context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 220,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Article Title
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Publication Date
            Text(
              DateFormat('MMMM d, y • h:mm a').format(article.pubDate),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Article Content (with fallbacks)
            _buildArticleContent(),
            const SizedBox(height: 20),

            // View Original Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _launchOriginalArticle(article.url, context),
                child: const Text('View Original Article'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleContent() {

    final content = article.content ?? article.description;

    if (content == null || content.isEmpty) {
      return Column(
        children: [
          const Icon(Icons.article, size: 50, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Full content not available in free version',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          const Text('Please view the original article for full content'),
        ],
      );
    }

    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        height: 1.6,
      ),
    );
  }

  Future<void> _launchOriginalArticle(String url, BuildContext context) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article URL not available')));
      return;
    }

    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open: ${e.toString()}')),
      );
    }
  }
}