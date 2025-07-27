import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/news_model.dart';

class NewsTile extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsTile({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with overlay
              Stack(
                children: [
                  _buildImageWidget(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black87,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(
                              color: Colors.orange.shade200,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.formattedDate,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        height: 260,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/default.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // child: const Center(
        //   child: Icon(Icons.article, size: 50, color: Colors.white54),
        // ),
      );
    }

    return CachedNetworkImage(
      imageUrl: article.imageUrl!,
      height: 260,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 260,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 260,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/default.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        //child: const Center(
        //child: Icon(Icons.broken_image, size: 50, color: Colors.white54),
        //),
      ),
    );
  }
}