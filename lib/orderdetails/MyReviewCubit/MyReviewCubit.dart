import 'package:dio/dio.dart';
import 'package:ecommerce/models/order_details_model.dart';
import 'package:ecommerce/orderdetails/MyReviewCubit/MyReviewRepository.dart';
import 'package:ecommerce/orderdetails/MyReviewCubit/MyReviewState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyReviewCubit extends Cubit<MyReviewState>{
  MyReviewCubit() : super(MyReviewInitial());
  MyReviewRepository myReviewRepository = MyReviewRepository();

  void updateReview(id,ordered_product_id,rating,review)  {
    emit(MyReviewUpdating());
    myReviewRepository.updateReview(id, ordered_product_id, rating, review).then((response) {
      emit(MyReviewUpdated(My_review.fromJson(response.data)));
    }).catchError((value) {
      print(value);
      DioError error = value;
      if (error.response != null) {
        try {
          emit(MyReviewFailed(error.response!.data));
        } catch (e) {
          emit(MyReviewFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(              MyReviewFailed("Please check your internet connection!"));
        } else {
          emit(MyReviewFailed(error.message));
        }
      }
    });

  }

}