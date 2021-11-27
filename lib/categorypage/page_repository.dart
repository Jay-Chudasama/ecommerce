
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants.dart';

class PageRepository {

  final Dio dio = Dio();

  Future<Response> loadCategories() async {
    final response = await dio.get(BASE_URL + "/categories/",);
    return response;
  }

  Future<Response> loadPage({required String category}) async {
    final response = await dio.get(BASE_URL + "/pagedata/",
        queryParameters: {'category': category,'limit':PAGE_LIMIT});
    return response;
  }

  Future<Response> loadMorePage({required String nextUrl}) async {
    final response = await dio.get(nextUrl,);
    return response;
  }

}