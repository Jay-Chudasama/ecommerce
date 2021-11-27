import 'package:ecommerce/models/wishlist_model.dart';

abstract class ViewAllState {}


class ViewAllInitial extends ViewAllState {}
class ViewAllLoading extends ViewAllState{}
class ViewAllLoaded extends ViewAllState{
  int count;
  String? next;
  String? previous;
  List<WishlistModel> products;

  ViewAllLoaded(this.count, this.next, this.previous, this.products);
}
class ViewAllLoadingFailed extends ViewAllState{
  String message;

  ViewAllLoadingFailed(this.message);
}

class MoreViewAllLoadingFailed extends ViewAllState{
  String message;
  ViewAllLoaded loadedViewAll;

  MoreViewAllLoadingFailed(this.message, this.loadedViewAll);
}