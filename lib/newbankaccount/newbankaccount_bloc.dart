import 'package:dio/dio.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'newbankaccount_event.dart';
import 'newbankaccount_repository.dart';
import 'newbankaccount_state.dart';

class NewBankAccountBloc extends Bloc<NewBankAccountEvent, NewBankAccountState> {
  NewBankAccountBloc() : super(NewBankAccountInitial());
  NewBankAccountRepository _newBankAccountRepository = NewBankAccountRepository();

  @override
  Stream<NewBankAccountState> mapEventToState(NewBankAccountEvent event) async* {
    NewBankAccountState newState;

    if (event is ValidatePincodeForBank) {
      newState = ValidatingPincodeForBank();
      yield newState;
      await _newBankAccountRepository
          .validatePincode(event.pincode)
          .then((response) {
        if(response.data[0]['Status']=="Error"){
          newState = InvalidPincodeForBank("Invalid Pincode!");

        }else{

          newState = PincodeValidatedForBank(response.data[0]['PostOffice'][0]['State']);
        }
      }).catchError((value) {
        DioError error = value;
        if (error.type == DioErrorType.other) {
          newState = InvalidPincodeForBank("Please check your internet connection!");
        } else {
          newState = InvalidPincodeForBank(error.message);
        }
      });
      yield newState;
    } else if (event is AddNewBankAccount) {
      newState = NewBankAccountSubmitting();
      yield newState;

      await _newBankAccountRepository.addNewBankAccount(event.bankAccount).then((response) {
        newState =
            NewBankAccountSubmitted(PayoutBeneficiaryModel.fromJson(response.data));
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = NewBankAccountFailed(error.response!.data);
          } catch (e) {
            newState = NewBankAccountFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                NewBankAccountFailed("Please check your internet connection!");
          } else {
            newState = NewBankAccountFailed(error.message);
          }
        }
      });
      yield newState;
    }
  }
}
