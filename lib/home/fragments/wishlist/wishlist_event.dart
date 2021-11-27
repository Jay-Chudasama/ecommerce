import 'package:ecommerce/home/fragments/wishlist/wishlist_state.dart';
import 'package:ecommerce/models/wishlist_model.dart';

abstract class WishlistEvent{}

class LoadWishlist extends WishlistEvent{}

class AddToWishlist extends WishlistEvent{
  late String id;

  AddToWishlist(this.id);

}

class RemoveFromWishlist extends WishlistEvent {
  late String id;

  RemoveFromWishlist(this.id);
}