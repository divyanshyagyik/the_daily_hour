import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/news_model.dart';
import '../model/news_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<NewsArticle>> _futureArticles;
  late Future<List<NewsArticle>> _futureHeadlines;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'technology';
  bool _isLoading = false;
  int _currentCarouselIndex = 0;

  final List<String> categories = [
    'technology',
    'business',
    'sports',
    'health',
    'science',
    'entertainment',
    'politics',
  ];

  @override
  void initState() {
    super.initState();
    _refreshNews();
    _fetchHeadlines();
  }

  void _refreshNews() {
    setState(() {
      _isLoading = true;
      _futureArticles = _newsService.fetchNews(
        category: _selectedCategory,
      ).whenComplete(() => setState(() => _isLoading = false));
    });
  }

  void _fetchHeadlines() {
    setState(() {
      _futureHeadlines = _newsService.fetchNews();
    });
  }

  void _searchNews() {
    setState(() {
      _isLoading = true;
      _futureArticles = _newsService.fetchNews(
        keyword: _searchController.text,
      ).whenComplete(() => setState(() => _isLoading = false));
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _refreshNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF213A50), Color(0xFF071938)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search news...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _refreshNews();
                        },
                      )
                          : null,
                    ),
                    onSubmitted: (_) => _searchNews(),
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // Caption
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Stay updated',
                              style: TextStyle(fontSize: 24, color: Colors.white70)),
                          Text('with',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white54)),
                          Text('The Daily Hour',
                              style: TextStyle(fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Headlines Carousel
                    FutureBuilder<List<NewsArticle>>(
                      future: _futureHeadlines,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox();
                        }

                        final headlines = snapshot.data!.take(5).toList();
                        return Column(
                          children: [
                            // In your HomeScreen's build method, replace the CarouselSlider.builder with this:
                            CarouselSlider.builder(
                              itemCount: headlines.length,
                              options: CarouselOptions(
                                height: 180,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16/9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                viewportFraction: 0.8,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentCarouselIndex = index;
                                  });
                                },
                              ),
                              itemBuilder: (context, index, realIndex) {
                                final article = headlines[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (article.url.isNotEmpty) {
                                      launchUrl(Uri.parse(article.url),
                                          mode: LaunchMode.inAppWebView);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: article.imageUrl != null && article.imageUrl!.isNotEmpty
                                          ? DecorationImage(
                                        image: NetworkImage(article.imageUrl!),
                                        fit: BoxFit.cover,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.black54,
                                          BlendMode.darken,
                                        ),
                                      )
                                          : const DecorationImage(
                                        image: AssetImage('assets/default.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article.source, // Show actual source instead of "Headline"
                                                  style: const TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  article.title, // Show actual title instead of "News Title"
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: headlines.asMap().entries.map((entry) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentCarouselIndex == entry.key
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Category Tiles
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => CategoryTile(
                          category: categories[index],
                          isSelected: _selectedCategory == categories[index],
                          onTap: _selectCategory,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // News List
                    _isLoading
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                        : FutureBuilder<List<NewsArticle>>(
                      future: _futureArticles,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'Failed to load news',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'No news available',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: snapshot.data!
                              .map(
                                (article) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: NewsTile(
                                article: article,
                                onTap: () {
                                  if (article.url.isNotEmpty) {
                                    launchUrl(Uri.parse(article.url),
                                        mode: LaunchMode.inAppWebView);
                                  }
                                },
                              ),
                            ),
                          )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(String) onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: isSelected ? Colors.white : Colors.orange,
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () => onTap(category),
          child: Container(
            constraints: const BoxConstraints(minWidth: 80),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Center(
              child: Text(
                category[0].toUpperCase() + category.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.orange : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
      margin: EdgeInsets.zero,
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
              // Image
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
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  article.displayContent,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
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
        height: 180,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/default.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Icon(Icons.article, size: 50, color: Colors.white54),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: article.imageUrl!,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 180,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 180,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/default.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.white54),
        ),
      ),
    );
  }
}