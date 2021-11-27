import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class TransactionRepository {
  final Dio dio = Dio();

  Future<Response> confirmTransaction(var data) async {
    final response = await dio.post(BASE_URL + "/notify_url/",data: data);
    return response;
  }
}
