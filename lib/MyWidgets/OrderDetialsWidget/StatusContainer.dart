import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/orderdetails/orderdetails_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils.dart';
import '../RoundedContainer.dart';

class StatusContainer extends StatelessWidget {
  bool shimmer=false;
  Color color = PRIMARY_SWATCH;
  bool showDate = true,cancelled1 = false,cancelled2 = false;
  late List<String?> dates;
  late OrderDetailsLoaded state;

  StatusContainer(this.state):dates = [state.details.orderedAt,state.details.packedAt,state.details.shippedAt,state.details.deliveredAt];


  StatusContainer.shimmer({this.shimmer=true});

  @override
  Widget build(BuildContext context) {
    return shimmer?_shimmerView():_originalView();
  }

  _originalView(){
    return  RoundedContainer(
        color: Colors.transparent,
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Status",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Stack(children: [
                    Positioned.fill(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          // This child will fill full height, replace it with your leading widget
                          child: Column(
                            children: [
                              ..._statusPath("ORDERED", state),
                              ..._statusPath("PACKED", state),
                              ..._statusPath("SHIPPED", state),
                              ..._statusPath("DELIVERED", state),
                              SizedBox(height: 16,),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._statusLabel("ORDERED", state),
                          ..._statusLabel("PACKED", state),
                          ..._statusLabel("SHIPPED", state),
                          ..._statusLabel("DELIVERED", state),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                        baseColor: Colors.blueGrey,
                        highlightColor: Colors.white,
                        child: Text(
                          state.details.status! == 'OUT_FOR_DELIVERY'?"OUT FOR DELIVERY":state.details.status!,
                          style: TextStyle(color: PRIMARY_SWATCH, fontSize: 18),
                        )),
                    Text(
                      _statusText(state.details.status),
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    )
                  ],
                ))
          ],
        ));
  }

  _shimmerView(){
    return  RoundedContainer(
        color: Colors.transparent,
        margin: EdgeInsets.all(8),
        child: ShimmerContainer(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(color:Colors.white,height: 26,width: 70,),
                    SizedBox(
                      height: 16,
                    ),
                    Stack(children: [
                      Positioned.fill(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            // This child will fill full height, replace it with your leading widget
                            child: Column(
                              children: [
                                ..._statusPath("ORDERED", null),
                                ..._statusPath("PACKED", null),
                                ..._statusPath("SHIPPED", null),
                                ..._statusPath("DELIVERED", null),
                                SizedBox(height: 16,),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(color:Colors.white,height: 30,width: 70,),
                            SizedBox(height: 24),
                            Container(color:Colors.white,height: 30,width: 70,),
                            SizedBox(height: 24),
                            Container(color:Colors.white,height: 30,width: 70,),
                            SizedBox(height: 24),
                            Container(color:Colors.white,height: 30,width: 70,),
                          ],
                        ),
                      )
                    ]),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(color:Colors.white,height: 40,width: 80,),

                    ],
                  ))
            ],
          ),
        ));
  }

  _statusPath(status, state) {
    if(!shimmer) {
      if (cancelled1)
        return [];

      if (state.details.status == 'CANCELLED') {
        if (dates[0] == null) {
          cancelled1 = true;
          return [
            Icon(FontAwesomeIcons.solidCircle, color: Colors.red, size: 16)];
        }
      }
      dates.removeAt(0);
    }

    var widget = [
      Icon(FontAwesomeIcons.solidCircle, color: color, size: 16),
      if (status != "DELIVERED" && status != "CANCELLED")
        Expanded(
          child: Container(
            color: color,
            width: 4,
          ),
        )
    ];
    if(!shimmer) {
      if (status == state.details.status ||
          status == 'SHIPPED' && state.details.status == "OUT_FOR_DELIVERY") {
        color = Colors.grey[400]!;
      }
    }
    return widget;
  }

  _statusLabel(status, state) {
    var timestamp;
    switch(status){
      case "ORDERED":
        timestamp = state.details.orderedAt;
        break;
      case "PACKED":
        timestamp = state.details.packedAt;
        break;
      case "SHIPPED":
        timestamp = state.details.shippedAt;
        break;
      case "DELIVERED":
        timestamp = state.details.deliveredAt;
        break;
      default:
        timestamp = "";
    }
    if(cancelled2)
      return [];


    if(timestamp == null && state.details.status == 'CANCELLED'){
      cancelled2 = true;
      status = "CANCELLED";
      timestamp = state.details.cancelledAt;
    }
    var widget = [
      Text(
        status,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 12,
          color: showDate?Colors.black:Colors.grey[400]
        ),
      ),
      Text(
        showDate && timestamp !=null?date(timestamp):"",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      if (status != "DELIVERED" && status != "CANCELLED") SizedBox(height: 24),
    ];
    if (status == state.details.status) {
      showDate = false;
    }
    return widget;
  }

  String _statusText(status) {

    switch(status){
      case "ORDERED":
        return "Your Item has been Ordered.";

      case "PACKED":
        return "Your Item has been packed and ready to be shipped.";

      case "SHIPPED":
        return "Your Item has been Shipped.";

      case "OUT_FOR_DELIVERY":
        return "Your Item is out for delivery and will be arrived soon .";

      case "DELIVERED":
        return "Your Item has been delivered.";

      case "CANCELLED":
        return "Your Item has been cancelled.";

      default:
        return "";
    }

  }
}
