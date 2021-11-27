import 'package:dio/dio.dart';
import 'package:ecommerce/models/review_model.dart';
import 'package:ecommerce/reviews/reviews_event.dart';
import 'package:ecommerce/reviews/reviews_repository.dart';
import 'package:ecommerce/reviews/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsBloc extends Bloc<ReviewsEvent,ReviewsState>{
  ReviewsBloc() : super(ReviewsInitial());
  ReviewsRepository _questionsRepository = ReviewsRepository();

  @override
  Stream<ReviewsState> mapEventToState(ReviewsEvent event) async*{
    ReviewsState newState;

    if (event is LoadReviews) {
      newState = ReviewsLoading();
      yield newState;
      await _questionsRepository.loadReviews(event.id).then((response) {
        var data = response.data;
        List<ReviewModel> list = List.from(
            data['results'].map((json) => ReviewModel.fromJson(json)));
        newState = ReviewsLoaded(
            data['count'], data['next'], data['previous'], list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = ReviewsLoadingFailed(error.response!.data);
          } catch (e) {
            newState = ReviewsLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                ReviewsLoadingFailed("Please check your internet connection!");
          } else {
            newState = ReviewsLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is LoadMoreReviews) {
      newState = state;
      ReviewsLoaded oldstate = state as ReviewsLoaded;
      ///same home.fragments.notification
      await _questionsRepository
          .loadMoreReviews(nextUrl: oldstate.next!)
          .then((response) {
        var data = response.data;
        List<ReviewModel> list = List.from(
            data['results'].map((json) => ReviewModel.fromJson(json)));
        oldstate.reviews.addAll(list);
        newState = ReviewsLoaded(data['count'], data['next'],
            data['previous'] ,oldstate.reviews);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = MoreReviewsLoadingFailed(error.response!.data,oldstate);
          } catch (e) {
            newState = MoreReviewsLoadingFailed(error.response!.data['detail'],oldstate);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                MoreReviewsLoadingFailed("Please check your internet connection!",oldstate);
          } else {
            newState = MoreReviewsLoadingFailed(error.message,oldstate);
          }
        }
      });
      yield newState;
    }
  }


}