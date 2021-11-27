import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/home/fragments/orders/orders_state.dart';
import 'package:ecommerce/models/orders_model.dart';
import 'package:ecommerce/orderdetails/orderdetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
import '../utils.dart';
import 'RoundedContainer.dart';
import 'ShimmerContainer.dart';

class OrderItem extends StatelessWidget {
  late OrdersLoaded state;
  late int index;

  bool shimmer = false;

  OrderItem.shimmer({this.shimmer = true});

  OrderItem(this.state, this.index);

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
                  child:
                      Container(height: 100, width: 100, color: Colors.white)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(height: 8,width: 80, color: Colors.white),
                      SizedBox(
                        height: 8,
                      ),
                      Container(height: 20, color: Colors.white),
                      SizedBox(
                        height: 8,
                      ),
                      Container(height: 10,width: 20, color: Colors.white),
                      SizedBox(
                        height: 8,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: RatingBarIndicator(
                            unratedColor: INPUT_BORDER_COLOR,
                            itemBuilder: (BuildContext context, int index) {
                              return Icon(
                                FontAwesomeIcons.solidStar,
                                color: Colors.amber,
                              );
                            },
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                          ))                ],
                  ),
                ),
              ),

            ],
          ),
        ));
  }

  _originalView(context) {
    OrdersModel model = state.orders[index];
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>OrderDetailsScreen(model.id!)));
      },
      child: RoundedContainer(
          margin: EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        date(model.orderedAt!),
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        model.title!,
                        style: TextStyle(height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          _statusPill(model.status),
                          Spacer(),
                          Text(
                            "Qty: " + model.quantity.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: RatingBarIndicator(
                            rating: model.rating!.toDouble(),
                            unratedColor: INPUT_BORDER_COLOR,
                            itemBuilder: (BuildContext context, int index) {
                              return Icon(
                                FontAwesomeIcons.solidStar,
                                color: Colors.amber,
                              );
                            },
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _statusPill(status) {
    switch (status) {
      case "ORDERED":
        return Shimmer.fromColors(
            baseColor: Colors.blueGrey,
            highlightColor: Colors.grey.shade300,
            child: Text(
              status,
              style: TextStyle(color: Colors.blueGrey),
            ));
      case "PACKED":
        return Shimmer.fromColors(
          baseColor: Colors.amber,
           highlightColor: Colors.grey.shade300,
          child: Text(
            status,
            style: TextStyle(color: Colors.amber),
          ),
        );
      case "SHIPPED":
        return Shimmer.fromColors(
          baseColor: Colors.blue,
           highlightColor: Colors.grey.shade300,
          child: Text(
            status,
            style: TextStyle(color: Colors.blue),
          ),
        );
      case "OUT_FOR_DELIVERY":
        return Shimmer.fromColors(
          baseColor: Colors.green,
           highlightColor: Colors.grey.shade300,
          child: Text(
            "OUT FOR DELIVERY",
            style: TextStyle(color: Colors.green),
          ),
        );

      default:
        return SizedBox();
    }
  }
}
