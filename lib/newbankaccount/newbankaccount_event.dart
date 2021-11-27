import 'package:ecommerce/models/payout_beneficiary_model.dart';

abstract class NewBankAccountEvent{}

class ValidatePincodeForBank extends NewBankAccountEvent{
  late int pincode;

  ValidatePincodeForBank(this.pincode);
}

class AddNewBankAccount extends NewBankAccountEvent{
  PayoutBeneficiaryModel bankAccount;

  AddNewBankAccount(this.bankAccount);
}
