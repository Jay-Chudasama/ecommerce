/// id : 1
/// title : "Realme 3 Pro lightning purple 64 GB RAM"
/// image : "/media/products/logo_Yji3LOZ.jpg"
/// ordered_at : "2021-09-06T18:50:15.851415Z"
/// rating : 3
/// quantity : 2

class OrdersModel {
  String? id;
  String? title;
  String? status;
  String? image;
  String? orderedAt;
  int? rating;
  int? quantity;

  OrdersModel({
      this.id, 
      this.title, 
      this.image, 
      this.status,
      this.orderedAt,
      this.rating, 
      this.quantity});

  OrdersModel.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    image = json["image"];
    status = json["status"];
    orderedAt = json["ordered_at"];
    rating = json["rating"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["image"] = image;
    map["status"] = status;
    map["ordered_at"] = orderedAt;
    map["rating"] = rating;
    map["quantity"] = quantity;
    return map;
  }

}