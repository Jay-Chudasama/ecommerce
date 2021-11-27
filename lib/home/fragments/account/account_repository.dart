
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class AccountRepository {

  final Dio dio = Dio();

  Future<Response> loadAddresses() async {
    final response = await dio.get(BASE_URL + "/myaddresses/",options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> loadBenes() async {
    final response = await dio.get(BASE_URL + "/mybenes/",options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> updateSelectedAddress(String id) async {
    final response = await dio.post(BASE_URL + "/update_selected_address/",data:{"id":id},options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> deleteAddress(id) async {
    final response = await dio.delete(BASE_URL + "/myaddresses/",queryParameters: {'id':id},options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> deleteBene(id) async {
    final response = await dio.delete(BASE_URL + "/mybenes/",queryParameters: {'id':id},options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
}