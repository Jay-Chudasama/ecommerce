import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/cart/cart_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_state.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:ecommerce/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'RoundedContainer.dart';

class CartItem extends StatelessWidget {
  late CartLoaded? state;
  late int index;
  late CartTotals cartTotals;

  bool shimmer = false;

  CartItem.shimmer({this.shimmer = true,this.index = 1});

  CartItem(this.state, this.index,this.cartTotals);

  @override
  Widget build(BuildContext context) {
    return shimmer
        ? _shimmerView()
        : index == 0
            ? _cartTotal()
            : _originalView(context);
  }

  _shimmerView() {
    if(index==0){
      return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: ShimmerContainer(child: Column(
          children: [
            Container(color: Colors.white,height: 26,width: 80,),
            Divider(),
            Container(color: Colors.white,height: 26,),
            Divider(),
            Container(color: Colors.white,height: 26,),
            Divider(),
            Container(color: Colors.white,height: 26,),
          ],
        ),

        ),
      );
    }
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: ShimmerContainer(
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                      Container(height: 100, width: 100, color: Colors.white)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Column(
                    children: [
                      Container(height: 20, color: Colors.white),
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
                  onPressed: null, icon: Icon(Icons.remove_circle_outline))
            ],
          ),
        ));
  }

  _cartTotal() {

    int totalAmount = cartTotals.totalAmount;

    if(state is CouponApplied){
      cartTotals.discountAmt = (state as CouponApplied).discountAmt;
      totalAmount = totalAmount - cartTotals.discountAmt;
    }


    return RoundedContainer(
      margin: EdgeInsets.all(8),
        child: Column(
      children: [
        Text(
          'CART TOTAL',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              'Price(Items ${cartTotals.itemCount})',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Text(
              CURRENCY + cartTotals.itemTotal.toString(),
              style: TextStyle(fontFamily: "",fontSize: 16),
            ),
          ],
        ),
        Divider(),
        Row(
          children: [
            Text(
              'Delivery charge',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Text(
              CURRENCY + cartTotals.deliveryCharge.toString(),
              style: TextStyle(fontFamily: "",fontSize: 16),
            ),
          ],
        ),
        if(cartTotals.discountAmt>0)...[
        Divider(),
        Row(
          children: [
            Text(
              'Coupon Code',
              style: TextStyle(fontSize: 16,color: Colors.pink),
            ),
            Spacer(),
            Text("- "+
              CURRENCY + cartTotals.discountAmt.toString(),
              style: TextStyle(fontFamily: "",fontSize: 16,color: Colors.red),
            ),
          ],
        ),],
        Divider(),
        Row(
          children: [
            Text(
              'TOTAL AMOUNT',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              CURRENCY + totalAmount.toString(),
              style: TextStyle(fontFamily: "",fontSize: 16,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ));
  }

  _originalView(context) {
    CartModel model = state!.cart[index - 1];
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
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
                          "(${model.option!})",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),

                        Row(
                          children: [
                            if (model.productDetails!.coupon != null)
                              Text(
                                "FREE COUPON",
                                style: TextStyle(
                                    color: model.quantity! > 0
                                        ? Colors.pink
                                        : Colors.grey[300],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),

                            Spacer(),
                            if (model.quantity! > 0) ...[
                              Text(
                                CURRENCY +
                                    model.productDetails!.price.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                CURRENCY +
                                    model.productDetails!.offerPrice.toString(),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ]
                          ],
                        ),
                        if (model.quantity! > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (model.productDetails!.cod!)
                                Text(
                                  "Cash on delivery",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: PRIMARY_SWATCH,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              Spacer(),
                              Icon(
                                FontAwesomeIcons.shippingFast,
                                color: PRIMARY_SWATCH,
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                model.productDetails!.deliveryCharge! > 0
                                    ? "+ " +
                                        CURRENCY +
                                        model.productDetails!.deliveryCharge
                                            .toString()
                                    : "FREE",
                                style: TextStyle(
                                    fontSize: 16,
//                                  fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context)
                          .add(RemoveFromCart(model.id!));
                      BlocProvider.of<AccountBloc>(context)
                          .add(RemoveFromUserCart(model.id!));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    )),
                Spacer(),
                if (model.quantity == 0)
                  Text(
                    "OUT OF STOCK",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                if (model.quantity! > 0)
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: INPUT_BORDER_COLOR, width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: model.selectedQuantity == 1
                                ? null
                                : () {
BlocProvider.of<CartBloc>(context).add(UpdateQuantity(model.id!,model.selectedQuantity!-1));
                                  },
                            icon: Icon(Icons.remove),
                            padding: EdgeInsets.all(4),
                            iconSize: 16),
                        Text(model.selectedQuantity.toString()),
                        IconButton(
                          onPressed: model.productDetails!.maxQuantity ==
                                      model.selectedQuantity ||
                                  model.quantity == model.selectedQuantity
                              ? null
                              : () {
                            BlocProvider.of<CartBloc>(context).add(UpdateQuantity(model.id!,model.selectedQuantity!+1));

                                },
                          icon: Icon(Icons.add),
                          padding: EdgeInsets.all(4),
                          iconSize: 16,
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ));
  }
}
