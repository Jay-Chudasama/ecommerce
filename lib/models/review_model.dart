/// id : "38ba37a0-2afe-4fb8-adc5-6155b0ea7a92"
/// user : "8469846308"
/// ordered_product : 25
/// rating : 2
/// review : "awesome"

class ReviewModel {
  String? id;
  String? user;
  String? orderedProduct;
  int? rating;
  String? review;

  ReviewModel({
      this.id, 
      this.user, 
      this.orderedProduct, 
      this.rating, 
      this.review});

  ReviewModel.fromJson(dynamic json) {
    id = json["id"];
    user = json["user"];
    orderedProduct = json["ordered_product"];
    rating = json["rating"];
    review = json["review"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["user"] = user;
    map["ordered_product"] = orderedProduct;
    map["rating"] = rating;
    map["review"] = review;
    return map;
  }

}