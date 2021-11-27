/// id : 1
/// image : "/media/products/logo_Yji3LOZ.jpg"
/// option : "sm"
/// quantity : 5
/// productDetails : {"id":1,"title":"Realme 3 Pro lightning purple 64 GB RAM","price":999,"offer_price":990,"COD":false,"max_quantity":1,"coupon":"2b3cc0cf-a045-43fa-ad12-605b2293edf6"}

class CartModel {
  String? id;
  String? image;
  String? option;
  int? quantity;
  int? selectedQuantity = 1;/// local for total calculations
  ProductDetails? productDetails;

  CartModel({
      this.id, 
      this.image, 
      this.option, 
      this.quantity, 
      this.productDetails});

  CartModel.fromJson(dynamic json) {
    id = json["id"];
    image = json["image"];
    option = json["option"];
    quantity = json["quantity"];
    productDetails = json["productDetails"] != null ? ProductDetails.fromJson(json["productDetails"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["image"] = image;
    map["option"] = option;
    map["quantity"] = quantity;
    if (productDetails != null) {
      map["productDetails"] = productDetails?.toJson();
    }
    return map;
  }

}

/// id : 1
/// title : "Realme 3 Pro lightning purple 64 GB RAM"
/// price : 999
/// offer_price : 990
/// COD : false
/// max_quantity : 1
/// delivery_charge : 0
/// coupon : "2b3cc0cf-a045-43fa-ad12-605b2293edf6"

class ProductDetails {
  String? id;
  String? title;
  int? price;
  int? offerPrice;
  int? deliveryCharge;
  bool? cod;
  int? maxQuantity;
  String? coupon;

  ProductDetails({
      this.id, 
      this.title, 
      this.price, 
      this.offerPrice, 
      this.deliveryCharge,
      this.cod,
      this.maxQuantity, 
      this.coupon});

  ProductDetails.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    price = json["price"];
    offerPrice = json["offer_price"];
    deliveryCharge = json["delivery_charge"];
    cod = json["COD"];
    maxQuantity = json["max_quantity"];
    coupon = json["coupon"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["price"] = price;
    map["offer_price"] = offerPrice;
    map["COD"] = cod;
    map["max_quantity"] = maxQuantity;
    map["delivery_charge"] = deliveryCharge;
    map["coupon"] = coupon;
    return map;
  }

}