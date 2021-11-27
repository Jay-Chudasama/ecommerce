import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/models/page_model.dart';
import 'package:ecommerce/productdetails/product_details_bloc.dart';
import 'package:ecommerce/productdetails/product_details_screen.dart';
import 'package:ecommerce/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class ProductThumbail extends StatelessWidget {
  Products product;
  double? width;
  bool shimmer;

  ProductThumbail(this.product, this.width, this.shimmer);

  @override
  Widget build(BuildContext context) {
    if (width == null) {
      width = (MediaQuery.of(context).size.width / 2) - 50;
    }
    return shimmer ? _shimmerView() : _originalView(context);
  }

  Widget _shimmerView() {
    return Container(
      margin: EdgeInsets.all(8),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 150,
              width: 150,
              color: Colors.white,
            ),
          )),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 15,
            width: 120,
            color: Colors.white,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                height: 20,
                width: 50,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                height: 15,
                width: 30,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _originalView(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ProductDetailBloc>(
                        create: (_) => ProductDetailBloc()),
                    BlocProvider.value(
                        value: BlocProvider.of<CartBloc>(context)),

                  ],
                  child: ProductDetailsScreen(product.id!),
                )));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                      imageUrl: DOMAIN_URL + product.image!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Icon(
                            Icons.broken_image_sharp,
                            color: Colors.grey,
                          ))),
            ),
            Row(
              children: [
                Text(
                  average(product),
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, height: 1.9),
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
            Text(
              product.title!,
              style: TextStyle(fontSize: 14, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text(
                  CURRENCY + product.offerPrice.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  CURRENCY + product.price.toString(),
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
    );
  }
}
