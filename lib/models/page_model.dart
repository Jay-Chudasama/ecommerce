/// count : 1
/// next : null
/// previous : null
/// results : [{"id":1,"position":0,"view_type":1,"image":null,"title":"fafsadfsdf","products":[{"id":1,"image":"/media/products/552d98c18e7b09712d65ab3d028a4d42.jpg","title":"Think and grow rich","price":1000,"offer_price":899}]}]
/// category : 1
/// slides : [{"position":0,"image":"/media/slides/48897.jpg"},{"position":0,"image":"/media/slides/mountains_sunset_landscape_144200_3840x2160.jpg"},{"position":0,"image":"/media/slides/10-12.jpg"}]

class PageModel {
  int? count;
  dynamic? next;
  dynamic? previous;
  List<Results>? results;
  String? category;
  List<Slides>? slides;

  PageModel({
      this.count, 
      this.next, 
      this.previous, 
      this.results, 
      this.category, 
      this.slides});

  PageModel.fromJson(dynamic json) {
    count = json["count"];
    next = json["next"];
    previous = json["previous"];
    if (json["results"] != null) {
      results = [];
      json["results"].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
    category = json["category"];
    if (json["slides"] != null) {
      slides = [];
      json["slides"].forEach((v) {
        slides?.add(Slides.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["count"] = count;
    map["next"] = next;
    map["previous"] = previous;
    if (results != null) {
      map["results"] = results?.map((v) => v.toJson()).toList();
    }
    map["category"] = category;
    if (slides != null) {
      map["slides"] = slides?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// position : 0
/// image : "/media/slides/48897.jpg"

class Slides {
  int? position;
  String? image;

  Slides({
      this.position, 
      this.image});

  Slides.fromJson(dynamic json) {
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

/// id : 1
/// position : 0
/// view_type : 1
/// image : null
/// title : "fafsadfsdf"
/// products : [{"id":1,"image":"/media/products/552d98c18e7b09712d65ab3d028a4d42.jpg","title":"Think and grow rich","price":1000,"offer_price":899}]

class Results {
  String? id;
  int? position;
  int? viewType;
  dynamic? image;
  String? title;
  List<Products>? products;

  Results({
      this.id, 
      this.position, 
      this.viewType, 
      this.image, 
      this.title, 
      this.products});

  Results.fromJson(dynamic json) {
    id = json["id"];
    position = json["position"];
    viewType = json["view_type"];
    image = json["image"];
    title = json["title"];
    if (json["product_options"] != null) {
      products = [];
      json["product_options"].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["position"] = position;
    map["view_type"] = viewType;
    map["image"] = image;
    map["title"] = title;
    if (products != null) {
      map["product_options"] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// image : "/media/products/552d98c18e7b09712d65ab3d028a4d42.jpg"
/// title : "Think and grow rich"
/// price : 1000
/// offer_price : 899

class Products {
  String? id;
  String? image;
  String? title;
  int? price;
  int? offerPrice;
  int? star5;
  int? star4;
  int? star3;
  int? star2;
  int? star1;

  Products({
      this.id, 
      this.image, 
      this.title, 
      this.price, 
      this.offerPrice,
    this.star5,
    this.star4,
    this.star3,
    this.star2,
    this.star1, });

  Products.fromJson(dynamic json) {
    id = json["id"];
    image = json["image"];
    title = json["title"];
    price = json["price"];
    offerPrice = json["offer_price"];
    star5 = json["star_5"];
    star4 = json["star_4"];
    star3 = json["star_3"];
    star2 = json["star_2"];
    star1 = json["star_1"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["image"] = image;
    map["title"] = title;
    map["price"] = price;
    map["offer_price"] = offerPrice;
    map["star_5"] = star5;
    map["star_4"] = star4;
    map["star_3"] = star3;
    map["star_2"] = star2;
    map["star_1"] = star1;
    return map;
  }

}