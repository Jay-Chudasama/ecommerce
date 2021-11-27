abstract class ReviewsEvent{}

class LoadReviews extends ReviewsEvent{
  String id;

  LoadReviews(this.id,);
}

class LoadMoreReviews extends ReviewsEvent{
}

