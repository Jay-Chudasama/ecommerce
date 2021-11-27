import 'package:dio/dio.dart';
import 'package:ecommerce/home/fragments/home/search_repository.dart';
import 'package:ecommerce/home/fragments/home/search_state.dart';
import 'package:ecommerce/models/wishlist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit() : super(SearchInitial());
  SearchRepository _searchRepository = SearchRepository();

  void search(query){
    emit(SearchLoading());
    _searchRepository.search(query).then((response) {
      var data = response.data;
      List<WishlistModel> list = List.from(
          data['results'].map((json) => WishlistModel.fromJson(json)));
      emit(SearchLoaded(
          data['count'], data['next'], data['previous'], list));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          SearchLoadingFailed(error.response!.data);
        } catch (e) {
          SearchLoadingFailed(error.response!.data['detail']);
        }
      } else {
        if (error.type == DioErrorType.other) {
          SearchLoadingFailed("Please check your internet connection!");
        } else {
          SearchLoadingFailed(error.message);
        }
      }
    });
  }


  void loadMore(){
    SearchLoaded oldstate = state as SearchLoaded;
    _searchRepository
        .moreResults(nextUrl: oldstate.next!)
        .then((response) {
      var data = response.data;
      List<WishlistModel> list = List.from(
          data['results'].map((json) => WishlistModel.fromJson(json)));
      oldstate.products.addAll(list);
      emit(SearchLoaded(
          data['count'], data['next'], data['previous'], list));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          SearchLoadingFailed(error.response!.data);
        } catch (e) {
          SearchLoadingFailed(error.response!.data['detail']);
        }
      } else {
        if (error.type == DioErrorType.other) {
          SearchLoadingFailed("Please check your internet connection!");
        } else {
          SearchLoadingFailed(error.message);
        }
      }
    });
  }
}