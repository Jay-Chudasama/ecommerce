import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constants.dart';

class LoginRepository {
  final Dio dio = Dio();

  Future<Response> login(
      {String? phone,String? email, required String password}) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final response = await dio.post(BASE_URL + "/login/", data: {
      'email':email,
      'phone': phone,
      'password': password,
      'fcmtoken': fcmToken,
    });
    return response;
  }
}
