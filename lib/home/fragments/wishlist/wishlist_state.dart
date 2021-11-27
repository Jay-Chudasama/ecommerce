import 'package:ecommerce/models/wishlist_model.dart';

abstract class WishlistState{}

class WishlistInitial extends WishlistState{}
class WishlistLoading extends WishlistState{}
class WishlistLoaded extends WishlistState{
  List<WishlistModel> wishlist;

  WishlistLoaded(this.wishlist);
}
class WishlistLoadingFailed extends WishlistState{
  String message;

  WishlistLoadingFailed(this.message);
}