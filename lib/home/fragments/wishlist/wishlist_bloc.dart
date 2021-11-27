import 'package:dio/dio.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_event.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_repository.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_state.dart';
import 'package:ecommerce/models/wishlist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistInitial());

  WishlistRepository _wishlistRepository = WishlistRepository();

  @override
  Stream<WishlistState> mapEventToState(WishlistEvent event) async* {
    WishlistState newState;

    if (event is LoadWishlist) {
      newState = WishlistLoading();
      yield newState;
      await _wishlistRepository.loadWishlist().then((response) {
        var data = response.data;
        List<WishlistModel> list =
            List.from(data.map((json) => WishlistModel.fromJson(json)));
        newState = WishlistLoaded(list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = WishlistLoadingFailed(error.response!.data);
          } catch (e) {
            newState = WishlistLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                WishlistLoadingFailed("Please check your internet connection!");
          } else {
            newState = WishlistLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is AddToWishlist) {
      newState = state;
      await _wishlistRepository.add(event.id).then((response) {
        if (state is WishlistLoaded) {
          List<WishlistModel> list = (state as WishlistLoaded).wishlist;
          list.add(WishlistModel.fromJson(response.data));
          newState = WishlistLoaded(list);
        }
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = WishlistLoadingFailed(error.response!.data);
          } catch (e) {
            newState = WishlistLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                WishlistLoadingFailed("Please check your internet connection!");
          } else {
            newState = WishlistLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is RemoveFromWishlist) {
      if (state is WishlistLoaded) {
        List<WishlistModel> list = (state as WishlistLoaded).wishlist;
        list.removeWhere((element) => element.id == event.id);
        newState = WishlistLoaded(list);
      } else {
        newState = state;
      }
      yield newState;
      await _wishlistRepository.remove(event.id).then((response) {
//       do nothing
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = WishlistLoadingFailed(error.response!.data);
          } catch (e) {
            newState = WishlistLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                WishlistLoadingFailed("Please check your internet connection!");
          } else {
            newState = WishlistLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    }
  }
}
