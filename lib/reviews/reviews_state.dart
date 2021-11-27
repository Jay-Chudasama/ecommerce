import 'package:ecommerce/models/question_model.dart';
import 'package:ecommerce/models/review_model.dart';

abstract class ReviewsState{}

class ReviewsInitial extends ReviewsState {}
class ReviewsLoading extends ReviewsState{}
class ReviewsLoaded extends ReviewsState{
  int count;
  String? next;
  String? previous;
  List<ReviewModel> reviews;

  ReviewsLoaded(this.count, this.next, this.previous, this.reviews);
}
class ReviewsLoadingFailed extends ReviewsState{
  String message;

  ReviewsLoadingFailed(this.message);
}

class MoreReviewsLoadingFailed extends ReviewsState{
  String message;
  ReviewsLoaded loadedReviews;

  MoreReviewsLoadingFailed(this.message, this.loadedReviews);
}

class PostingQuestion extends ReviewsState{}
