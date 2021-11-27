import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class NotificationRepository {

  final Dio dio = Dio();

  Future<Response> loadNotifications() async {
    final response = await dio.get(BASE_URL + "/notifications/",
        queryParameters: {'limit':NOTIFICATIONS_PAGE_LIMIT},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> loadMoreNotifications({required String nextUrl}) async {
    final response = await dio.get(nextUrl,
        options: Options(headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

}