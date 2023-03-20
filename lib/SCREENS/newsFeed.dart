import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:newsnow/SERVICES/articleServices.dart';
import 'package:newsnow/WIDGETS/newsCard.dart';
import 'detailPage.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController query = TextEditingController();
  final ArticaleServices articaleServices = ArticaleServices();
  ScrollController scrollController = ScrollController();
  bool showBackToTopButton = false;
  bool isSearching = false;
  int page = 1;
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

  @override
  void didChangeDependencies() {
    precacheImage(Image.asset("assets/images/background.jpg").image, context);
    super.didChangeDependencies();
  }

  ////////function to load all the news
  void loadNews() async {
    articaleServices.isLoading.value = true;
    //////////// get the news
    try {
      await articaleServices.getNews(
        page: page,
        pageSize: 20,
        query: searchQuery,
      );
      ///// add all the news to a new list to track the pagination
      setState(() {
        articaleServices.addedListNews.addAll(articaleServices.listNews);
        articaleServices.isLoading.value = false;
      });
    } catch (e) {
      setState(() {
        articaleServices.isLoading.value = false;
      });
    }
  }

//////// function to load more news
  void loadMoreNews() {
    if (!articaleServices.isLoading.value) {
      setState(() {
        page++;
      });

      loadNews();
    }
  }

//////// function to search for a specific news using keywords
  void searchNews(String query) {
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
              SliverAppBar(
                  backgroundColor: Colors.grey,
                  floating: true,
                  snap: true,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: SizedBox(
                        width: 220,
                        child: searchBar(),
                      ),
                      background: Image.asset(
                        "assets/images/background.jpg",
                        fit: BoxFit.cover,
                      ))),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == articaleServices.addedListNews.length) {
                      return articaleServices.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            )
                          : articaleServices.addedListNews.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 140, vertical: 8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    onPressed: loadMoreNews,
                                    child: const Text('Load more'),
                                  ),
                                )
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 150,
                                    ),
                                    const Text(
                                      "No news found with the given keyword",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          searchQuery = "";
                                          isSearching = false;
                                          query.clear();
                                          loadNews();
                                        });
                                      },
                                      child: const Text('Load All news'),
                                    ),
                                  ],
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
                  backgroundColor: Colors.grey,
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

  searchBar() {
    return CupertinoTextField(
      controller: query,
      cursorColor: Colors.grey,
      keyboardType: TextInputType.text,
      placeholder: "Search..",
      placeholderStyle: const TextStyle(
        color: Color(0xffC4C6CC),
        fontSize: 14.0,
      ),
      suffix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
            onTap: () {
              setState(() {
                ///////for changing the search close icons
                if (query.text.isNotEmpty && isSearching == false) {
                  isSearching = true;
                } else {
                  isSearching = false;
                  query.clear();
                }
              });
              FocusManager.instance.primaryFocus?.unfocus();
              searchNews(query.text);
            },
            child: isSearching == false
                ? const Icon(
                    Icons.search,
                  )
                : const Icon(
                    Icons.close,
                  )),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
    );
  }
}
