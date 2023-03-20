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
}
