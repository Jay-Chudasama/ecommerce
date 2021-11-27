import 'package:ecommerce/models/product_details_model.dart';

/// coupon : {"minimum_spend":50,"maximum_discounted_amount":100,"discount_type":2,"discount":25,"validity_period":28}
/// code : "MYMALL"
/// validity : "2021-09-09"
/// activated : true
/// used : false

class MyCouponModel {
  Coupon? coupon;
  String? code;
  String? validity;
  bool? activated;
  bool? used;

  MyCouponModel({
      this.coupon, 
      this.code, 
      this.validity, 
      this.activated, 
      this.used});

  MyCouponModel.fromJson(dynamic json) {
    coupon = json["coupon"] != null ? Coupon.fromJson(json["coupon"]) : null;
    code = json["code"];
    validity = json["validity"];
    activated = json["activated"];
    used = json["used"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (coupon != null) {
      map["coupon"] = coupon?.toJson();
    }
    map["code"] = code;
    map["validity"] = validity;
    map["activated"] = activated;
    map["used"] = used;
    return map;
  }

}

