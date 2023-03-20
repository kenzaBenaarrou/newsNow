import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:newsnow/SERVICES/articleServices.dart';
import 'package:newsnow/WIDGETS/newsCard.dart';

import '../WIDGETS/searchBar.dart';
import 'detailPage.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ArticaleServices articaleServices = ArticaleServices();
  ScrollController scrollController = ScrollController();
  bool showBackToTopButton = false;
  List<dynamic> news = [];
  int page = 1;
  bool loading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        showBackToTopButton = scrollController.position.pixels >= 100;
      });
    });
    loadNews();
  }

  Future loadNews() async {
    setState(() {
      loading = true;
    });

    try {
      final List<dynamic> news = await articaleServices.getNews(
        page: page,
        pageSize: 20,
        query: searchQuery,
      );

      setState(() {
        articaleServices.addedListNews.addAll(articaleServices.listNews);
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(news.length.toString()),
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _loadMoreNews() {
    if (!loading) {
      setState(() {
        page++;
      });

      loadNews();
    }
  }

  void _searchNews(String query) {
    setState(() {
      searchQuery = query;
      page = 1;
      articaleServices.addedListNews.clear();
    });

    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: scrollController,
            slivers: [
              const SliverAppBar(
                  backgroundColor: Colors.grey,
                  // title: Text('News'),
                  floating: true,
                  snap: true,
                  expandedHeight: 300,
                  actions: [],
                  flexibleSpace: SearchBar()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == articaleServices.addedListNews.length) {
                      return loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 140, vertical: 8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                onPressed: _loadMoreNews,
                                child: const Text('Load more'),
                              ),
                            );
                    } else {
                      return InkWell(
                        onTap: () => Get.to(() => DetailPage(
                            article: articaleServices.addedListNews[index])),
                        child: NewsCard(
                          article: articaleServices.addedListNews[index],
                        ),
                      );
                    }
                  },
                  childCount: articaleServices.addedListNews.length + 1,
                ),
              ),
            ],
          ),
          floatingActionButton: showBackToTopButton
              ? FloatingActionButton(
                  onPressed: () {
                    scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: const Icon(Icons.arrow_upward),
                )
              : null,
        ),
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search news';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Searching for "$query"...'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
