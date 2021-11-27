import 'order_details_model.dart';

/// id : 1
/// options : [{"id":1,"images":[{"position":0,"image":"/media/products/logo_Yji3LOZ.jpg"},{"position":0,"image":"/media/products/color-burst-3.jpg"}],"option":"sm","quantity":5},{"id":2,"images":[{"position":0,"image":"/media/products/splash_icon.png"}],"option":"m","quantity":10}]
/// coupon : {"minimum_spend":50,"maximum_discounted_amount":100,"discount_type":1,"discount":25,"validity_period":28}
/// category : 2
/// title : "Realme 3 Pro lightning purple 64 GB RAM"
/// description : "All kind of mobile phones available"
/// specifications : [{"title":"material","value":"leather"},{"title":"waterproof","value":"YES"},{"title":"keylace","value":"BLACK"}]
/// price : 999
/// offer_price : 990
/// star_5 : 0
/// star_4 : 0
/// star_3 : 0
/// star_2 : 0
/// star_1 : 0
/// max_quantity : 1
/// COD : false
/// reviews : [{"rating":3,"review":"OK"},{"rating":5,"review":"OK"},{"rating":2,"review":"awesome"}]
/// questions : [{"question":"dsfdfsf?","answer":"dfgdfg"}]
/// my_rating : 0

class ProductDetailsModel {
  String? id;
  List<Options>? options;
  Coupon? coupon;
  String? category;
  String? title;
  String? description;
  List<Specifications>? specifications;
  int? price;
  int? offerPrice;
  int? deliveryCharge;
  int? star5;
  int? star4;
  int? star3;
  int? star2;
  int? star1;
  int? maxQuantity;
  bool? cod;
  List<Reviews>? reviews;
  List<Questions>? questions;
  My_review? myReview;

  ProductDetailsModel({
      this.id, 
      this.options, 
      this.coupon, 
      this.category, 
      this.title, 
      this.description, 
      this.specifications, 
      this.price, 
      this.offerPrice,
    this.deliveryCharge,
      this.star5, 
      this.star4, 
      this.star3, 
      this.star2, 
      this.star1, 
      this.maxQuantity, 
      this.cod, 
      this.reviews, 
      this.questions, 
      this.myReview});

  ProductDetailsModel.fromJson(dynamic json) {
    id = json["id"];
    if (json["options"] != null) {
      options = [];
      json["options"].forEach((v) {
        options?.add(Options.fromJson(v));
      });
    }
    coupon = json["coupon"] != null ? Coupon.fromJson(json["coupon"]) : null;
    category = json["category"];
    title = json["title"];
    description = json["description"];
    if (json["specifications"] != null) {
      specifications = [];
      json["specifications"].forEach((v) {
        specifications?.add(Specifications.fromJson(v));
      });
    }
    price = json["price"];
    offerPrice = json["offer_price"];
    deliveryCharge = json["delivery_charge"];
    star5 = json["star_5"];
    star4 = json["star_4"];
    star3 = json["star_3"];
    star2 = json["star_2"];
    star1 = json["star_1"];
    maxQuantity = json["max_quantity"];
    cod = json["COD"];
    if (json["reviews"] != null) {
      reviews = [];
      json["reviews"].forEach((v) {
        reviews?.add(Reviews.fromJson(v));
      });
    }
    if (json["questions"] != null) {
      questions = [];
      json["questions"].forEach((v) {
        questions?.add(Questions.fromJson(v));
      });
    }
    if(json["my_review"]!=null) {
      myReview = My_review.fromJson(json["my_review"]);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    if (options != null) {
      map["options"] = options?.map((v) => v.toJson()).toList();
    }
    if (coupon != null) {
      map["coupon"] = coupon?.toJson();
    }
    map["category"] = category;
    map["title"] = title;
    map["description"] = description;
    if (specifications != null) {
      map["specifications"] = specifications?.map((v) => v.toJson()).toList();
    }
    map["price"] = price;
    map["offer_price"] = offerPrice;
    map["delivery_charge"] = deliveryCharge;
    map["star_5"] = star5;
    map["star_4"] = star4;
    map["star_3"] = star3;
    map["star_2"] = star2;
    map["star_1"] = star1;
    map["max_quantity"] = maxQuantity;
    map["COD"] = cod;
    if (reviews != null) {
      map["reviews"] = reviews?.map((v) => v.toJson()).toList();
    }
    if (questions != null) {
      map["questions"] = questions?.map((v) => v.toJson()).toList();
    }
    map["my_review"] = myReview;
    return map;
  }

}

/// question : "dsfdfsf?"
/// answer : "dfgdfg"

class Questions {
  String? question;
  String? answer;

  Questions({
      this.question, 
      this.answer});

  Questions.fromJson(dynamic json) {
    question = json["question"];
    answer = json["answer"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["question"] = question;
    map["answer"] = answer;
    return map;
  }

}

/// rating : 3
/// review : "OK"

class Reviews {
  int? rating;
  String? review;

  Reviews({
      this.rating, 
      this.review});

  Reviews.fromJson(dynamic json) {
    rating = json["rating"];
    review = json["review"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rating"] = rating;
    map["review"] = review;
    return map;
  }

}

/// title : "material"
/// value : "leather"

class Specifications {
  String? title;
  String? value;

  Specifications({
      this.title, 
      this.value});

  Specifications.fromJson(dynamic json) {
    title = json["title"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["value"] = value;
    return map;
  }

}

/// minimum_spend : 50
/// maximum_discounted_amount : 100
/// discount_type : 1
/// discount : 25
/// validity_period : 28

class Coupon {
  int? minimumSpend;
  int? maximumDiscountedAmount;
  int? discountType;
  int? discount;
  int? validityPeriod;

  Coupon({
      this.minimumSpend, 
      this.maximumDiscountedAmount, 
      this.discountType, 
      this.discount, 
      this.validityPeriod});

  Coupon.fromJson(dynamic json) {
    minimumSpend = json["minimum_spend"];
    maximumDiscountedAmount = json["maximum_discounted_amount"];
    discountType = json["discount_type"];
    discount = json["discount"];
    validityPeriod = json["validity_period"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["minimum_spend"] = minimumSpend;
    map["maximum_discounted_amount"] = maximumDiscountedAmount;
    map["discount_type"] = discountType;
    map["discount"] = discount;
    map["validity_period"] = validityPeriod;
    return map;
  }

}

/// id : 1
/// images : [{"position":0,"image":"/media/products/logo_Yji3LOZ.jpg"},{"position":0,"image":"/media/products/color-burst-3.jpg"}]
/// option : "sm"
/// quantity : 5

class Options {
  String? id;
  List<Images>? images;
  String? option;
  int? quantity;

  Options({
      this.id, 
      this.images, 
      this.option, 
      this.quantity});

  Options.fromJson(dynamic json) {
    id = json["id"];
    if (json["images"] != null) {
      images = [];
      json["images"].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    option = json["option"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    if (images != null) {
      map["images"] = images?.map((v) => v.toJson()).toList();
    }
    map["option"] = option;
    map["quantity"] = quantity;
    return map;
  }

}

/// position : 0
/// image : "/media/products/logo_Yji3LOZ.jpg"

class Images {
  int? position;
  String? image;

  Images({
      this.position, 
      this.image});

  Images.fromJson(dynamic json) {
    position = json["position"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["position"] = position;
    map["image"] = image;
    return map;
  }

}