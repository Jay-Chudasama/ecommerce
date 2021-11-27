import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../utils.dart';

const FLAT_DISCOUNT = 1;
const PERCENTAGE_DISCOUNT = 2;

class CouponItem extends StatelessWidget {
  late Coupon _coupon;
  bool shimmer = false;
  String? validity,code;

  CouponItem.shimmer({this.shimmer = true});

  CouponItem(this._coupon,{this.validity,this.code});

  @override
  Widget build(BuildContext context) {
    if (shimmer) {
      return _shimmerView();
    } else {
      return _originalView(context);
    }
  }

  _shimmerView() {
    return ShimmerContainer(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: COUPON_COLOR, borderRadius: BorderRadius.circular(5)),
        child: DottedBorder(
          color: Colors.white,
          dashPattern: [7, 5],
          strokeWidth: 2,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                color: Colors.white,
              ),
              Container(
                height: 25,
                color: Colors.white,
              ),
              Container(
                height: 25,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _originalView(context) {
    String body;
    if (_coupon.discountType == FLAT_DISCOUNT) {
      body =
          "Get Flat ${CURRENCY + _coupon.discount.toString()} OFF on any purchase of ${CURRENCY + _coupon.minimumSpend.toString()} and above.";
    } else {
      body =
          "Get ${_coupon.discount.toString()}% OFF on any purchase of ${CURRENCY + _coupon.minimumSpend.toString()} and above.";
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: COUPON_COLOR, borderRadius: BorderRadius.circular(5)),
      child: DottedBorder(
        color: Colors.white,
        dashPattern: [7, 5],
        strokeWidth: 2,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _coupon.discountType == FLAT_DISCOUNT
                  ? "Flat ${CURRENCY + _coupon.discount.toString()} OFF"
                  : "GET ${_coupon.discount.toString()}% DISCOUNT",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              body,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "* Maximum limit is ${CURRENCY + _coupon.maximumDiscountedAmount.toString()}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 10),
            ),
            if(code!=null)
              Row(
                children: [
                  Text(
                  code!,
                  style: TextStyle(color: Colors.white,fontSize: 30),
            ),Spacer(),
                  IconButton(
                      onPressed:(){
                        Clipboard.setData(new ClipboardData(text: code)).then((_){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Coupon Code Copied!"),
                            backgroundColor: Colors.green,
                          ));
                        });
                  },icon: Icon(Icons.copy,color: Colors.white,))
                ],
              ),
            if(validity!=null)
            Text(
              "Validity ${fullDate(validity!)}",
              style: TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
