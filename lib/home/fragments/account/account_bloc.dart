import 'package:dio/dio.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_repository.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(AccountState initialState) : super(initialState);
  AccountRepository _accountRepository = AccountRepository();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is RemoveFromUserWishlist) {
      state.userdata.wishlist!.remove(event.id);
      yield AccountInitial(state.userdata);
    }
    if (event is AddToUserWishlist) {
      state.userdata.wishlist!.add(event.id);
      yield AccountInitial(state.userdata);
    }
    if (event is RemoveFromUserCart) {
      state.userdata.cart!.remove(event.id);
      yield AccountInitial(state.userdata);
    }
    if (event is AddToUserCart) {
      state.userdata.cart!.add(event.id);
      yield AccountInitial(state.userdata);
    }
    if(event is AddNotificationCount){
      state.userdata.notifications=state.userdata.notifications! + 1;
      yield AccountInitial(state.userdata);
    }
    if (event is NotificationsReaded) {
      state.userdata.notifications = 0;
      yield AccountInitial(state.userdata);
    }
    if (event is LoadMyAddresses) {
      AccountState newState;
      newState = AddressesLoading(state.userdata);
      yield newState;
      await _accountRepository.loadAddresses().then((response) {
        var data = response.data;
        List<Selected_address> list =
            List.from(data.map((json) => Selected_address.fromJson(json)));
        newState = AddressesLoaded(state.userdata,list,state.myBankAccounts);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = AddressesLoadingFailed(error.response!.data,state.userdata);
          } catch (e) {
            newState = AddressesLoadingFailed(error.response!.data['detail'],state.userdata);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                AddressesLoadingFailed("Please check your internet connection!",state.userdata);
          } else {
            newState = AddressesLoadingFailed(error.message,state.userdata);
          }
        }
      });
      yield newState;
    }
    if(event is AddAddress){
      state.myaddresses!.insert(0,event.selected_address);
      state.userdata.selectedAddress = event.selected_address;
      yield AddressesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }
    if(event is UpdateAccountAddress){
      state.myaddresses![state.myaddresses!.indexWhere((element) => element.id==event.selected_address.id)] = event.selected_address;
      if(state.userdata.selectedAddress!.id==event.selected_address.id){
        state.userdata.selectedAddress =event.selected_address;
      }
      yield AddressesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }

    if(event is UpdateSelectedAddress){
      state.userdata.selectedAddress = event.selected_address;
      _accountRepository.updateSelectedAddress(event.selected_address.id!);
      yield AddressesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }

    if (event is DeleteAddress) {
      state.myaddresses!.removeWhere((element) => element.id==event.id);
      if(state.userdata.selectedAddress!.id==event.id){
        state.userdata.selectedAddress =null;
      }
      _accountRepository.deleteAddress(event.id);
      yield AddressesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }




    if(event is RemovedOrderedProductsUserCart){
      state.userdata.cart!.removeWhere((element) => event.cartTotals.cartItemIds.contains(element));
      yield AccountInitial(state.userdata);
    }

    if (event is LoadMyBenes) {
      AccountState newState;
      newState = BenesLoading(state.userdata);
      yield newState;
      await _accountRepository.loadBenes().then((response) {
        var data = response.data;
        List<PayoutBeneficiaryModel> list =
        List.from(data.map((json) => PayoutBeneficiaryModel.fromJson(json)));
        newState = BenesLoaded(state.userdata,state.myaddresses,list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = BenesLoadingFailed(error.response!.data,state.userdata);
          } catch (e) {
            newState = BenesLoadingFailed(error.response!.data['detail'],state.userdata);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                BenesLoadingFailed("Please check your internet connection!",state.userdata);
          } else {
            newState = BenesLoadingFailed(error.message,state.userdata);
          }
        }
      });
      yield newState;
    }
    if(event is AddBene){
      state.myBankAccounts!.insert(0,event.bene);
      yield BenesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }

    if(event is UpdateSelectedBene){
      yield BenesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }
    if (event is DeleteBene) {
      state.myBankAccounts!.removeWhere((element) => element.id==event.id);
      _accountRepository.deleteBene(event.id);
      yield BenesLoaded(state.userdata,state.myaddresses,state.myBankAccounts);
    }
    if(event is UpdateInfo){
      state.userdata.email = event.email;
      state.userdata.phone = event.phone;
      state.userdata.fullname = event.name;
      yield AccountInitial(state.userdata,myaddresses: state.myaddresses,myBankAccounts: state.myBankAccounts);
    }
  }
}
