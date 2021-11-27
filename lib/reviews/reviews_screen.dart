import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/QuestionItem.dart';
import 'package:ecommerce/MyWidgets/ReviewItem.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/reviews/reviews_bloc.dart';
import 'package:ecommerce/reviews/reviews_event.dart';
import 'package:ecommerce/reviews/reviews_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class ReviewsScreen extends StatelessWidget {

  late String id;

  ReviewsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Reviews'),),
      body: BlocConsumer<ReviewsBloc, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsInitial) {
              BlocProvider.of<ReviewsBloc>(context).add(LoadReviews(id));
            }

            if (state is ReviewsLoadingFailed) {
              return FailureMessage(
                message: state.message,
                onRetry: () {
                  BlocProvider.of<ReviewsBloc>(context)
                      .add(LoadReviews(id));
                },
              );
            }
            if (state is ReviewsLoaded ||
                state is MoreReviewsLoadingFailed) {
              ReviewsLoaded _loadedReviews =
              state is MoreReviewsLoadingFailed
                  ? state.loadedReviews
                  : state as ReviewsLoaded;

                return _loadedReviews.reviews.length>0?ListView.builder(
                  itemBuilder: (context, index) {
                    if (index < _loadedReviews.reviews.length) {
                      return ReviewItem(_loadedReviews.reviews[index]);
                    } else {
                      if (state is MoreReviewsLoadingFailed) {
                        return FailureMessage(
                            message: state.message, onRetry: null);
                      }
                      BlocProvider.of<ReviewsBloc>(context)
                          .add(LoadMoreReviews());
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  itemCount: _loadedReviews.next != null
                      ? _loadedReviews.reviews.length + 1
                      : _loadedReviews.reviews.length,
                ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
            }

            return ListView.builder(itemBuilder: (context,index){
              return ReviewItem.shimmer();
            },);
          }, listener: (context, state) {
        if (state is ReviewsLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
        if (state is MoreReviewsLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
      }),
    );
  }



}
