import 'package:ecommerce/models/user_model.dart';

abstract class NewAddressEvent{}

class ValidatePincode extends NewAddressEvent{
  late int pincode;

  ValidatePincode(this.pincode);
}

class AddNewAddress extends NewAddressEvent{
  Selected_address address;

  AddNewAddress(this.address);
}


class UpdateAddress extends NewAddressEvent{
  Selected_address address;

  UpdateAddress(this.address);
}
