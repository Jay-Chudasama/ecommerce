import 'package:ecommerce/models/user_model.dart';

/// id : 1
/// order : {"id":"7766ef6b-99ec-4b46-871a-17eb5c8e891f","payment_mode":"PREPAID","address":{"id":1,"city":"Ahmedabad","locality":"gsdfgsdfg","flat_no":"56s  sdfg sdfg","pincode":534535,"state":"Gujarat","landmark":"sdfgdf dfg","name":"sgdfgsdfgsdfg","mobile_no":"9876542134","alternate_no":""},"tx_id":"","tx_status":"INITIATED"}
/// product_option : {"title":"Realme 3 Pro lightning purple 64 GB RAM","option":"sm","image":"/media/products/logo_Yji3LOZ.jpg"}
/// product_price : 0
/// delivery_price : 0
/// tx_price : 0
/// quantity : 2
/// ordered_at : "2021-09-08T18:09:07.339177+05:30"
/// packed_at : ""
/// shipped_at : ""
/// delivered_at : ""
/// cancelled_at : ""
/// status : "ORDERED"
/// my_review : {"rating":3,"review":"awesome"}

class OrderDetailsModel {
  String? id;
  Order? order;
  Product_option? productOption;
  int? productPrice;
  int? deliveryPrice;
  int? txPrice;
  int? quantity;
  String? orderedAt;
  String? packedAt;
  String? shippedAt;
  String? deliveredAt;
  String? cancelledAt;
  String? status;
  My_review? myReview;

  OrderDetailsModel({
      this.id, 
      this.order, 
      this.productOption, 
      this.productPrice, 
      this.deliveryPrice, 
      this.txPrice, 
      this.quantity, 
      this.orderedAt, 
      this.packedAt, 
      this.shippedAt, 
      this.deliveredAt, 
      this.cancelledAt, 
      this.status, 
      this.myReview});

  OrderDetailsModel.fromJson(dynamic json) {
    id = json["id"];
    order = json["order"] != null ? Order.fromJson(json["order"]) : null;
    productOption = json["product_option"] != null ? Product_option.fromJson(json["product_option"]) : null;
    productPrice = json["product_price"];
    deliveryPrice = json["delivery_price"];
    txPrice = json["tx_price"];
    quantity = json["quantity"];
    orderedAt = json["ordered_at"];
    packedAt = json["packed_at"];
    shippedAt = json["shipped_at"];
    deliveredAt = json["delivered_at"];
    cancelledAt = json["cancelled_at"];
    status = json["status"];
    myReview = json["my_review"] != null ? My_review.fromJson(json["my_review"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    if (order != null) {
      map["order"] = order?.toJson();
    }
    if (productOption != null) {
      map["product_option"] = productOption?.toJson();
    }
    map["product_price"] = productPrice;
    map["delivery_price"] = deliveryPrice;
    map["tx_price"] = txPrice;
    map["quantity"] = quantity;
    map["ordered_at"] = orderedAt;
    map["packed_at"] = packedAt;
    map["shipped_at"] = shippedAt;
    map["delivered_at"] = deliveredAt;
    map["cancelled_at"] = cancelledAt;
    map["status"] = status;
    if (myReview != null) {
      map["my_review"] = myReview?.toJson();
    }
    return map;
  }

}

/// rating : 3
/// review : "awesome"

class My_review {
  String? id;
  int? rating;
  String? review;

  My_review({
      this.id,
      this.rating,
      this.review});

  My_review.fromJson(dynamic json) {
    rating = json["rating"];
    review = json["review"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rating"] = rating;
    map["review"] = review;
    map["id"] = id;
    return map;
  }

}

/// title : "Realme 3 Pro lightning purple 64 GB RAM"
/// option : "sm"
/// image : "/media/products/logo_Yji3LOZ.jpg"

class Product_option {
  String? title;
  String? option;
  String? image;

  Product_option({
      this.title, 
      this.option, 
      this.image});

  Product_option.fromJson(dynamic json) {
    title = json["title"];
    option = json["option"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["option"] = option;
    map["image"] = image;
    return map;
  }

}

/// id : "7766ef6b-99ec-4b46-871a-17eb5c8e891f"
/// payment_mode : "PREPAID"
/// address : {"id":1,"city":"Ahmedabad","locality":"gsdfgsdfg","flat_no":"56s  sdfg sdfg","pincode":534535,"state":"Gujarat","landmark":"sdfgdf dfg","name":"sgdfgsdfgsdfg","mobile_no":"9876542134","alternate_no":""}
/// tx_id : ""
/// tx_status : "INITIATED"

class Order {
  String? id;
  String? paymentMode;
  Selected_address? address;
  String? txId;
  String? txStatus;

  Order({
      this.id, 
      this.paymentMode, 
      this.address, 
      this.txId, 
      this.txStatus});

  Order.fromJson(dynamic json) {
    id = json["id"];
    paymentMode = json["payment_mode"];
    address = json["address"] != null ? Selected_address.fromJson(json["address"]) : null;
    txId = json["tx_id"];
    txStatus = json["tx_status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["payment_mode"] = paymentMode;
    if (address != null) {
      map["address"] = address?.toJson();
    }
    map["tx_id"] = txId;
    map["tx_status"] = txStatus;
    return map;
  }

}

