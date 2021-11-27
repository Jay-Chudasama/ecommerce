import 'package:ecommerce/models/wishlist_model.dart';

abstract class SearchState {}


class SearchInitial extends SearchState {}
class SearchLoading extends SearchState{}
class SearchLoaded extends SearchState{
  int count;
  String? next;
  String? previous;
  List<WishlistModel> products;

  SearchLoaded(this.count, this.next, this.previous, this.products);
}
class SearchLoadingFailed extends SearchState{
  String message;

  SearchLoadingFailed(this.message);
}

class MoreSearchLoadingFailed extends SearchState{
  String message;
  SearchLoaded loadedSearch;

  MoreSearchLoadingFailed(this.message, this.loadedSearch);
}