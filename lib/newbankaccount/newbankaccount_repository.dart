import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class NewBankAccountRepository {

  final Dio dio = Dio();

  Future<Response> addNewBankAccount(PayoutBeneficiaryModel bankAccount) async {
    final response = await dio.post(BASE_URL + "/mybenes/",data:bankAccount.toJson(),options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> validatePincode(pincode) async {
    final response = await dio.get("https://api.postalpincode.in/pincode/"+pincode.toString(),);
    return response;
  }

}