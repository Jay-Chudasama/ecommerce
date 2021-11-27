import 'package:ecommerce/models/payout_beneficiary_model.dart';

abstract class NewBankAccountState{}

class NewBankAccountInitial extends NewBankAccountState{}
class ValidatingPincodeForBank extends NewBankAccountState{}
class PincodeValidatedForBank extends NewBankAccountState{
  late String state;

  PincodeValidatedForBank(this.state);
}

class InvalidPincodeForBank extends NewBankAccountState{
  late String message;

  InvalidPincodeForBank(this.message);
}

class NewBankAccountSubmitting extends NewBankAccountState{}

class NewBankAccountSubmitted extends NewBankAccountState{
  late  PayoutBeneficiaryModel bankAccount;

  NewBankAccountSubmitted(this.bankAccount);
}

class NewBankAccountFailed extends NewBankAccountState{
  late String message;

  NewBankAccountFailed(this.message);
}