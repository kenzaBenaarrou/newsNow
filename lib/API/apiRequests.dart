import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'apiParams.dart';

class ApiRequest {
  Dio dio = Dio(BaseOptions(
    baseUrl: API.apiBaseUrl,
    queryParameters: {'apiKey': API.apikey},
  ));

  ////// for a better view
  var log = Logger();

  // get(String subUrl, query) async {
  //   try {
  //     var response = await dio.get(subUrl, queryParameters: query);

  //     if (response.statusCode == 200) {
  //       log.i(response.data);
  //       log.i(response.statusCode);
  //       return json.decode(response.data);
  //     } else {
  //       log.i(response.data);
  //       log.i(response.statusCode);
  //       return json.decode(response.data);
  //     }
  //   } catch (err) {
  //     return err;
  //   }
  // }
}
