/// email : "jaychudasama402@gmail.com"
/// phone : "8469846308"
/// fullname : "Jay Chudasama"
/// wishlist : [1,2]
/// selected_address : {"id":1,"city":"Ahmedabad","locality":"gsdfgsdfg","flat_no":"56s  sdfg sdfg","pincode":534535,"state":"Gujarat","landmark":"sdfgdf dfg","name":"sgdfgsdfgsdfg","mobile_no":"9876542134","alternate_no":""}
/// cart : [1]
/// created_at : "2021-09-01T15:37:35.310654+05:30"
/// updated_at : "2021-09-05T12:51:56.693155+05:30"

class UserModel {
  String? email;
  String? phone;
  String? fullname;
  List<String>? wishlist;
  Selected_address? selectedAddress;
  List<String>? cart;
  int? notifications;
  String? createdAt;
  String? updatedAt;

  UserModel({
      this.email, 
      this.phone, 
      this.fullname, 
      this.wishlist, 
      this.selectedAddress, 
      this.cart,
    this.notifications,
      this.createdAt, 
      this.updatedAt});

  UserModel.fromJson(dynamic json) {
    email = json["email"];
    phone = json["phone"];
    fullname = json["fullname"];
    notifications = json['notifications'];
    wishlist = json["wishlist"] != null ? json["wishlist"].cast<String>() : [];
    selectedAddress = json["selected_address"] != null ? Selected_address.fromJson(json["selected_address"]) : null;
    cart = json["cart"] != null ? json["cart"].cast<String>() : [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = email;
    map["phone"] = phone;
    map["fullname"] = fullname;
    map["wishlist"] = wishlist;
    if (selectedAddress != null) {
      map["selected_address"] = selectedAddress?.toJson();
    }
    map["cart"] = cart;
    map["notifications"] = notifications;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}

/// id : 1
/// city : "Ahmedabad"
/// locality : "gsdfgsdfg"
/// flat_no : "56s  sdfg sdfg"
/// pincode : 534535
/// state : "Gujarat"
/// landmark : "sdfgdf dfg"
/// name : "sgdfgsdfgsdfg"
/// mobile_no : "9876542134"
/// alternate_no : ""

class Selected_address {
  String? id;
  String? city;
  String? locality;
  String? flatNo;
  int? pincode;
  String? state;
  String? landmark;
  String? name;
  String? mobileNo;
  String? alternateNo;

  Selected_address({
      this.id, 
      this.city, 
      this.locality, 
      this.flatNo, 
      this.pincode, 
      this.state, 
      this.landmark, 
      this.name, 
      this.mobileNo, 
      this.alternateNo});

  Selected_address.fromJson(dynamic json) {
    id = json["id"];
    city = json["city"];
    locality = json["locality"];
    flatNo = json["flat_no"];
    pincode = json["pincode"];
    state = json["state"];
    landmark = json["landmark"];
    name = json["name"];
    mobileNo = json["mobile_no"];
    alternateNo = json["alternate_no"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["city"] = city;
    map["locality"] = locality;
    map["flat_no"] = flatNo;
    map["pincode"] = pincode;
    map["state"] = state;
    map["landmark"] = landmark;
    map["name"] = name;
    map["mobile_no"] = mobileNo;
    map["alternate_no"] = alternateNo;
    return map;
  }

}