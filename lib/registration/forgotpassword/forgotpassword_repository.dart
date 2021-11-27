import 'package:dio/dio.dart';

import '../../constants.dart';

class ForgotPasswordRepository {
  final Dio dio = Dio();

  Future<Response> reset_password(
      {required String email}) async {
    final response = await dio.post(BASE_URL + "/password_reset_email/", data: {
      'email':email,
    });
    return response;
  }
}
