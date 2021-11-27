import 'package:dio/dio.dart';
import 'package:ecommerce/models/wishlist_model.dart';
import 'package:ecommerce/viewall/viewall_repository.dart';
import 'package:ecommerce/viewall/viewall_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllCubit extends Cubit<ViewAllState>{
  ViewAllCubit() : super(ViewAllInitial());
  ViewAllRepository _viewallRepository = ViewAllRepository();

  void load(id){
    emit(ViewAllLoading());
    _viewallRepository.load(id).then((response) {
      var data = response.data;
      List<WishlistModel> list = List.from(
          data['results'].map((json) => WishlistModel.fromJson(json)));
      emit(ViewAllLoaded(
          data['count'], data['next'], data['previous'], list));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ViewAllLoadingFailed(error.response!.data));
        } catch (e) {
          emit(ViewAllLoadingFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ViewAllLoadingFailed("Please check your internet connection!"));
        } else {
          emit(ViewAllLoadingFailed(error.message));
        }
      }
    });
  }


  void loadMore(){
    ViewAllLoaded oldstate = state as ViewAllLoaded;
    _viewallRepository
        .moreResults(nextUrl: oldstate.next!)
        .then((response) {
      var data = response.data;
      List<WishlistModel> list = List.from(
          data['results'].map((json) => WishlistModel.fromJson(json)));
      oldstate.products.addAll(list);
      emit(ViewAllLoaded(
          data['count'], data['next'], data['previous'], list));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ViewAllLoadingFailed(error.response!.data));
        } catch (e) {
          emit(ViewAllLoadingFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ViewAllLoadingFailed("Please check your internet connection!"));
        } else {
          emit(ViewAllLoadingFailed(error.message));
        }
      }
    });
  }
}