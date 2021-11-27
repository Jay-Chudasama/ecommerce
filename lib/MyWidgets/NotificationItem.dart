import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../utils.dart';
import 'RoundedContainer.dart';
import 'ShimmerContainer.dart';

class NotificationItem extends StatelessWidget {
  late bool shimmer =false;
  late NotificationModel model;


  NotificationItem(this.model);

  NotificationItem.shimmer({this.shimmer=true});

  @override
  Widget build(BuildContext context) {
    return shimmer?_shimmerView():_originalView(context);
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

                      SizedBox(
                        height: 8,
                      ),

                          Container(height: 25,  color: Colors.white),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ));
  }

  _originalView(context) {
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            if(model.image != null)
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      date(model.createdAt!),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      model.title!,
                      style: TextStyle(height: 1.4),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      model.body!,
                      style: TextStyle(fontSize: 12,color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
