import 'package:ecommerce/models/order_details_model.dart';

abstract class MyReviewState{}

class MyReviewInitial extends MyReviewState{}
class MyReviewUpdating extends MyReviewState{}
class MyReviewUpdated extends MyReviewState{

  My_review my_review;

  MyReviewUpdated(this.my_review);
}
class MyReviewFailed extends MyReviewState{
  String message;

  MyReviewFailed(this.message);
}