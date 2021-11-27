import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_event.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_state.dart';
import 'package:ecommerce/models/wishlist_model.dart';
import 'package:ecommerce/productdetails/product_details_bloc.dart';
import 'package:ecommerce/productdetails/product_details_screen.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:ecommerce/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'ProductDetailsWidget/ProductLikeButton.dart';
import 'RoundedContainer.dart';

class WishlistItem extends StatelessWidget {
  late int index;
  late WishlistModel model;
  late bool display;

  bool shimmer = false;

  WishlistItem.shimmer({this.shimmer = true});

  WishlistItem(this.model, this.index,{this.display=true});

  @override
  Widget build(BuildContext context) {
    return shimmer ? _shimmerView() : _originalView(context);
  }

  _shimmerView() {
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: ShimmerContainer(
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(height: 100, width: 100, color: Colors.white)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Column(
                    children: [
                      Container(height: 20,  color: Colors.white),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(height: 15, width: 15, color: Colors.white),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            FontAwesomeIcons.solidStar,
                            size: 12,
                            color: Colors.amber,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(height: 25, width: 60, color: Colors.white),
                          SizedBox(
                            width: 8,
                          ),
                          Container(height: 20, width: 50, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_circle_outline))
            ],
          ),
        ));
  }

  _originalView(context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<ProductDetailBloc>(
                    create: (_) => ProductDetailBloc()),
                BlocProvider.value(
                    value: BlocProvider.of<CartBloc>(context)),

              ],
              child: ProductDetailsScreen(model.productDetails!.id!),
            )));
      },
      child: RoundedContainer(
          margin: EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                      imageUrl: DOMAIN_URL + model.image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Icon(
                            Icons.broken_image_sharp,
                            color: Colors.grey,
                          ))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.productDetails!.title!,
                        style: TextStyle(height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "(${model.option!})",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                      ),

                      Row(
                        children: [
                          Text(
                            average(model.productDetails),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                height: 1.9),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            FontAwesomeIcons.solidStar,
                            size: 12,
                            color: Colors.amber,
                          )
                        ],
                      ),
                      if(model.quantity==0)
                        Text(
                          "OUT OF STOCK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.red),
                        ),
                      if(model.quantity!>0)
                      Row(
                        children: [
                          Text(
                            CURRENCY + model.productDetails!.offerPrice.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            CURRENCY + model.productDetails!.price.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                fontFamily: "Roboto"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              display?

              ProductLikeButton(model.id!):
              IconButton(
                  onPressed: () {
                    BlocProvider.of<WishlistBloc>(context)
                        .add(RemoveFromWishlist(model.id!));
                    BlocProvider.of<AccountBloc>(context)
                        .add(RemoveFromUserWishlist(model.id!));
                    ;
                  },
                  icon: Icon(Icons.remove_circle_outline))
            ],
          )),
    );
  }
}
