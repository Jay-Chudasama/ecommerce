/// id : 1
/// title : "fsdfsdf"
/// body : "fsdfasdf"
/// image : null
/// seen : false
/// created_at : "2021-09-17T17:39:11.942835+05:30"

class NotificationModel {
  String? id;
  String? title;
  String? body;
  dynamic? image;
  bool? seen;
  String? createdAt;

  NotificationModel({
      this.id, 
      this.title, 
      this.body, 
      this.image, 
      this.seen, 
      this.createdAt});

  NotificationModel.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    body = json["body"];
    image = json["image"];
    seen = json["seen"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["body"] = body;
    map["image"] = image;
    map["seen"] = seen;
    map["created_at"] = createdAt;
    return map;
  }

}