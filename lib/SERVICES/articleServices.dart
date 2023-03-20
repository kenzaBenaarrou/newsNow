import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:newsnow/MODELS/articleModel.dart';

import '../API/apiParams.dart';
import '../API/apiRequests.dart';

class ArticaleServices extends GetxController {
  final listNews = <Article>[].obs;
  final addedListNews = <Article>[].obs;
  final isLoading = false.obs;
  // Dio dio = Dio(
  //   BaseOptions(
  //     baseUrl: API.apiBaseUrl,
  //     queryParameters: {'apiKey': API.apikey},
  //     // headers: {'Authorization': 'Bearer ${API.apikey}'},
  //   ),
  // );

  // getNews({int page = 1, pageSize = 20, String query = ''}) async {
  //   try {
  //     isLoading.value = true;
  //     var response = await ApiRequest().get('/top-headlines', {
  //       'country': 'us',
  //       'pageSize': 10,
  //       'page': page,
  //       'q': query,
  //     });
  //     print(response["article"]);
  //     // if (response["status"] == 200) {
  //     // print(response);
  //     // final List<Article> articles =
  //     //     articleFromJson(jsonEncode(response.data['articles']));
  //     // listNews.value = articles.toList(growable: false);
  //     // print(listNews.length);
  //     // return listNews;
  //     // } else {
  //     //   throw Exception('Failed to fetch news');
  //     // }
  //   } catch (err) {
  //     print('-----------error');
  //     print(err);
  //     isLoading.value = false;
  //   }
  // }

  Future getNews({int page = 1, pageSize = 20, String query = ''}) async {
    isLoading.value = true;
    final response =
        await ApiRequest().dio.get('/top-headlines', queryParameters: {
      'country': 'us',
      'pageSize': 10,
      'page': page,
      'q': query,
    });
    ApiRequest().log.i(response.data);
    if (response.statusCode == 200) {
      final List<Article> articles =
          articleFromJson(jsonEncode(response.data['articles']));
      listNews.value = articles.toList(growable: false);
      isLoading.value = true;
      return listNews;
    } else {
      isLoading.value = true;
      throw Exception('Failed to fetch news');
    }
  }
}
