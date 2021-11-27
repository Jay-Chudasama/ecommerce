import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';

abstract class AccountState {
  UserModel userdata;
  List<Selected_address>? myaddresses;
  List<PayoutBeneficiaryModel>? myBankAccounts;

  AccountState(this.userdata, {this.myaddresses,this.myBankAccounts});
}

class AccountInitial extends AccountState {
  AccountInitial(UserModel userdata,{ List<Selected_address>? myaddresses,List<PayoutBeneficiaryModel>? myBankAccounts}) : super(userdata,myaddresses: myaddresses,myBankAccounts: myBankAccounts);
}

class AddressesLoading extends AccountState{
  AddressesLoading(UserModel userdata) : super(userdata);

}

class AddressesLoadingFailed extends AccountState{
  late String message;

  AddressesLoadingFailed(this.message,UserModel userdata) : super(userdata);
}

class AddressesLoaded extends AccountInitial{
  AddressesLoaded(UserModel userdata, List<Selected_address>? list, List<PayoutBeneficiaryModel>? myBankAccounts) : super(userdata,myaddresses:list,myBankAccounts: myBankAccounts);

}

class BenesLoading extends AccountState{
  BenesLoading(UserModel userdata) : super(userdata);

}

class BenesLoadingFailed extends AccountState{
  late String message;

  BenesLoadingFailed(this.message,UserModel userdata) : super(userdata);
}

class BenesLoaded extends AccountInitial{
  BenesLoaded(UserModel userdata, List<Selected_address>? list, List<PayoutBeneficiaryModel>? myBankAccounts) : super(userdata,myaddresses:list,myBankAccounts: myBankAccounts);

}
