import 'package:ecommerce/models/user_model.dart';

abstract class NewAddressState{}

class NewAddressInitial extends NewAddressState{}
class ValidatingPincode extends NewAddressState{}
class PincodeValidated extends NewAddressState{
  late String state;

  PincodeValidated(this.state);
}

class InvalidPincode extends NewAddressState{
  late String message;

  InvalidPincode(this.message);
}

class NewAddressSubmitting extends NewAddressState{}

class NewAddressSubmitted extends NewAddressState{
late  Selected_address newAddress;

  NewAddressSubmitted(this.newAddress);
}

class NewAddressFailed extends NewAddressState{
  late String message;

  NewAddressFailed(this.message);
}