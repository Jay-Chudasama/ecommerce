import 'package:dio/dio.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/newaddress/newaddress_event.dart';
import 'package:ecommerce/newaddress/newaddress_repository.dart';
import 'package:ecommerce/newaddress/newaddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewAddressBloc extends Bloc<NewAddressEvent, NewAddressState> {
  NewAddressBloc() : super(NewAddressInitial());
  NewAddressRepository _newAddressRepository = NewAddressRepository();

  @override
  Stream<NewAddressState> mapEventToState(NewAddressEvent event) async* {
    NewAddressState newState;

    if (event is ValidatePincode) {
      newState = ValidatingPincode();
      yield newState;
      await _newAddressRepository
          .validatePincode(event.pincode)
          .then((response) {
        if(response.data[0]['Status']=="Error"){
          newState = InvalidPincode("Invalid Pincode!");

        }else{

        newState = PincodeValidated(response.data[0]['PostOffice'][0]['State']);
        }
      }).catchError((value) {
        DioError error = value;
        if (error.type == DioErrorType.other) {
          newState = InvalidPincode("Please check your internet connection!");
        } else {
          newState = InvalidPincode(error.message);
        }
      });
      yield newState;
    } else if (event is AddNewAddress) {
      newState = NewAddressSubmitting();
      yield newState;

      await _newAddressRepository.addNewAddress(event.address).then((response) {
        newState =
            NewAddressSubmitted(Selected_address.fromJson(response.data));
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = NewAddressFailed(error.response!.data);
          } catch (e) {
            newState = NewAddressFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                NewAddressFailed("Please check your internet connection!");
          } else {
            newState = NewAddressFailed(error.message);
          }
        }
      });
      yield newState;
    }else if (event is UpdateAddress) {
      newState = NewAddressSubmitting();
      yield newState;

      await _newAddressRepository.updateAddress(event.address).then((response) {
        newState =
            NewAddressSubmitted(Selected_address.fromJson(response.data));
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = NewAddressFailed(error.response!.data);
          } catch (e) {
            newState = NewAddressFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                NewAddressFailed("Please check your internet connection!");
          } else {
            newState = NewAddressFailed(error.message);
          }
        }
      });
      yield newState;
    }
  }
}
