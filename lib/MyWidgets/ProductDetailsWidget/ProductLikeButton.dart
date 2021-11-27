import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';

import '../../constants.dart';

class ProductLikeButton extends StatelessWidget {

  late String selectedOptionId;


  ProductLikeButton(this.selectedOptionId);

  @override
  Widget build(BuildContext context) {
    AccountBloc _accountBloc = BlocProvider.of<AccountBloc>(context);

    return LikeButton(
        bubblesColor: BubblesColor(
          dotSecondaryColor: Colors.redAccent,
          dotPrimaryColor: PRIMARY_SWATCH,
        ),
        likeBuilder: (bool isLiked) {
          return isLiked
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 28,
                )
              : Icon(
                  Icons.favorite_border_outlined,
                  size: 28,
                );
        },
        isLiked: _accountBloc.state.userdata.wishlist!
            .contains(selectedOptionId),
        onTap: (bool isLiked) async {
          WishlistBloc wishlistbloc = BlocProvider.of<WishlistBloc>(context);
          if (_accountBloc.state.userdata.wishlist!
              .contains(selectedOptionId)) {
            _accountBloc
                .add(RemoveFromUserWishlist(selectedOptionId));

            wishlistbloc
                .add(RemoveFromWishlist(selectedOptionId));
          } else {
            _accountBloc
                .add(AddToUserWishlist(selectedOptionId));
            wishlistbloc.add(AddToWishlist(selectedOptionId));
          }
          return !isLiked;
        });
  }
}
