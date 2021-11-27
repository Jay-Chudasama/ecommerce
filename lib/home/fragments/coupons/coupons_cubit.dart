import 'package:dio/dio.dart';
import 'package:ecommerce/home/fragments/coupons/coupons_repository.dart';
import 'package:ecommerce/home/fragments/coupons/coupons_state.dart';
import 'package:ecommerce/models/my_coupon_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CouponsCubit extends Cubit<CouponsState>{
  CouponsCubit() : super(CouponsInitial());
  CouponsRepository _couponsRepository = CouponsRepository();

  void loadCoupons(){
    emit(CouponsLoading());
    _couponsRepository.loadCoupons().then((response) {
      var data = response.data;
      List<MyCouponModel> list =
      List.from(data.map((json) => MyCouponModel.fromJson(json)));
      emit(CouponsLoaded(list));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(CouponsLoadingFailed(error.response!.data));
        } catch (e) {
          emit(CouponsLoadingFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(              CouponsLoadingFailed("Please check your internet connection!"));
        } else {
          emit(CouponsLoadingFailed(error.message));
        }
      }
    });
  }

}