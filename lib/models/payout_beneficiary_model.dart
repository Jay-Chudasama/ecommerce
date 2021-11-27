/// id : 1
/// name : "jay"
/// email : "jay@gmail.com"
/// phone : "9876542134"
/// bankAccount : "4234234234234"
/// ifsc : "HDFC0000001"
/// address1 : "saf"
/// city : "Ahmedabad"
/// state : "Gujarat"
/// pincode : 534535

class PayoutBeneficiaryModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? bankAccount;
  String? ifsc;
  String? address1;
  String? city;
  String? state;
  int? pincode;

  PayoutBeneficiaryModel({
      this.id, 
      this.name, 
      this.email, 
      this.phone, 
      this.bankAccount, 
      this.ifsc, 
      this.address1, 
      this.city, 
      this.state, 
      this.pincode});

  PayoutBeneficiaryModel.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    bankAccount = json["bankAccount"];
    ifsc = json["ifsc"];
    address1 = json["address1"];
    city = json["city"];
    state = json["state"];
    pincode = json["pincode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    map["phone"] = phone;
    map["bankAccount"] = bankAccount;
    map["ifsc"] = ifsc;
    map["address1"] = address1;
    map["city"] = city;
    map["state"] = state;
    map["pincode"] = pincode;
    return map;
  }

}