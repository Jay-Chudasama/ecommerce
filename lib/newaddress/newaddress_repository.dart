import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class NewAddressRepository {

  final Dio dio = Dio();

  Future<Response> addNewAddress(Selected_address address) async {
    final response = await dio.post(BASE_URL + "/myaddresses/",data:address.toJson(),options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> updateAddress(Selected_address address) async {
    final response = await dio.put(BASE_URL + "/myaddresses/",data:address.toJson(),options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }



  Future<Response> validatePincode(pincode) async {
    final response = await dio.get("https://api.postalpincode.in/pincode/"+pincode.toString(),);
    return response;
  }

}