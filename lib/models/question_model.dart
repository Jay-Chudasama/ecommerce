/// id : "50eee1fd-4c56-4683-9653-aa2508f692c0"
/// user : "8469846308"
/// product : 1
/// question : "dsfdfsf?"
/// answer : "dfgdfg"
/// created_at : "2021-09-11T22:05:58.449675+05:30"
/// updated_at : "2021-09-11T22:05:58.449675+05:30"

class QuestionModel {
  String? id;
  String? user;
  String? product;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  QuestionModel({
      this.id, 
      this.user, 
      this.product, 
      this.question, 
      this.answer, 
      this.createdAt, 
      this.updatedAt});

  QuestionModel.fromJson(dynamic json) {
    id = json["id"];
    user = json["user"];
    product = json["product"];
    question = json["question"];
    answer = json["answer"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["user"] = user;
    map["product"] = product;
    map["question"] = question;
    map["answer"] = answer;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}