/// id : 2
/// image : "/media/products/splash_icon.png"
/// option : "m"
/// quantity : 7
/// productDetails : {"id":1,"title":"Realme 3 Pro lightning purple 64 GB RAM","price":999,"offer_price":990,"star_1":0,"star_2":0,"star_3":5,"star_4":0,"star_5":10}

class WishlistModel {
  String? id;
  String? image;
  String? option;
  int? quantity;
  ProductDetails? productDetails;

  WishlistModel({
      this.id, 
      this.image, 
      this.option, 
      this.quantity, 
      this.productDetails});

  WishlistModel.fromJson(dynamic json) {
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
/// star_1 : 0
/// star_2 : 0
/// star_3 : 5
/// star_4 : 0
/// star_5 : 10

class ProductDetails {
  String? id;
  String? title;
  int? price;
  int? offerPrice;
  int? star1;
  int? star2;
  int? star3;
  int? star4;
  int? star5;

  ProductDetails({
      this.id, 
      this.title, 
      this.price, 
      this.offerPrice, 
      this.star1, 
      this.star2, 
      this.star3, 
      this.star4, 
      this.star5});

  ProductDetails.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    price = json["price"];
    offerPrice = json["offer_price"];
    star1 = json["star_1"];
    star2 = json["star_2"];
    star3 = json["star_3"];
    star4 = json["star_4"];
    star5 = json["star_5"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["price"] = price;
    map["offer_price"] = offerPrice;
    map["star_1"] = star1;
    map["star_2"] = star2;
    map["star_3"] = star3;
    map["star_4"] = star4;
    map["star_5"] = star5;
    return map;
  }

}