import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/newaddress/newaddress_bloc.dart';
import 'package:ecommerce/newaddress/newaddress_event.dart';
import 'package:ecommerce/newaddress/newaddress_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class NewAddressScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  Selected_address address = Selected_address();
  Selected_address? model;

  NewAddressScreen({this.model}){
    if(model!=null){
      address.id = model!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model!=null?"Edit Address":"New Address"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: BlocConsumer<NewAddressBloc, NewAddressState>(
            listener: (context, state) {
              if (state is PincodeValidated) {
                address.state = state.state;
                if(model!=null){
                  context.read<NewAddressBloc>().add(UpdateAddress(address));
                }else{
                context.read<NewAddressBloc>().add(AddNewAddress(address));
                }
              }
              if (state is NewAddressSubmitted) {
                if(model!=null){
                  BlocProvider.of<AccountBloc>(context)
                      .add(UpdateAccountAddress(state.newAddress));
                }else{
                BlocProvider.of<AccountBloc>(context)
                    .add(AddAddress(state.newAddress));
                }
                Navigator.pop(context);
              }
              if (state is InvalidPincode) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
              if (state is NewAddressFailed) {
                if (state.message == UNAUTHENTICATED_USER) {
                  BlocProvider.of<AuthCubit>(context).removeToken();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ///force logout
                }
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                      "assets/images/address.png",
                      width: 120,
                    )),
                    SizedBox(
                      height: 16,
                    ),
                    _flatField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 16,
                    ),
                    _localityField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 16,
                    ),
                    _landmarkField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 16,
                    ),
                    _cityField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _pincodeField(
                                !(state is ValidatingPincode) &&
                                    !(state is NewAddressSubmitting),
                                state is InvalidPincode
                                    ? state.message
                                    : null)),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(child: _stateField(state)),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    _nameField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 16,
                    ),
                    _mobileField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 16,
                    ),
                    _alternateField(!(state is ValidatingPincode) &&
                        !(state is NewAddressSubmitting)),
                    SizedBox(
                      height: 36,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            )),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 50))),
                        onPressed: (state is NewAddressSubmitting ||
                                state is ValidatingPincode)
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<NewAddressBloc>(context)
                                      .add(ValidatePincode(address.pincode!));
                                }
                              },
                        child: (state is NewAddressSubmitting ||
                                state is ValidatingPincode)
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                                width: 25,
                                height: 25,
                              )
                            : Text(
                                model!=null?"Update":'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _cityField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        address.city = value;
      },
      initialValue: model?.city,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'City',
      ),
    );
  }

  Widget _localityField(enabled) {
    return TextFormField(
      enabled: enabled,
      maxLines: 3,
      style: TextStyle(fontSize: 14),
      initialValue: model?.locality,
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        address.locality = value;
      },
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Locality,area or street',
      ),
    );
  }

  Widget _flatField(enabled) {
    return TextFormField(
      enabled: enabled,
      maxLines: 2,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        address.flatNo = value;
      },
      initialValue: model?.flatNo,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Flat no., Building name',
      ),
    );
  }

  Widget _pincodeField(enabled, error) {
    return TextFormField(
      maxLength: 6,
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        address.pincode = int.parse(value);
      },
      initialValue: model?.pincode.toString(),
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        errorText: error,
        filled: true,
        labelText: 'Pincode',
      ),
    );
  }

  Widget _stateField(state) {
    return TextFormField(
      enabled: false,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        address.state = value;
      },
      initialValue: state is PincodeValidated ? state.state : address.state,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        disabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: state is PincodeValidated ? state.state : "State",
      ),
    );
  }

  Widget _landmarkField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        address.landmark = value;
      },
      initialValue: model?.landmark,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Landmark(Optional)',
      ),
    );
  }

  Widget _nameField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        address.name = value;
      },
      initialValue: model?.name,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Name',
      ),
    );
  }

  Widget _mobileField(enabled) {
    return TextFormField(
      maxLength: 10,
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length != 10) {
          return "Please enter a valid Phone number!";
        }
        address.mobileNo = value;
      },
      initialValue: model?.mobileNo,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Mobile no.',
      ),
    );
  }

  Widget _alternateField(enabled) {
    return TextFormField(
      maxLength: 10,
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (value!.isNotEmpty && value.length != 10) {
          return "Please enter a valid Phone number!";
        }
        address.alternateNo = value;
      },
      initialValue: model?.alternateNo,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Alternate no.',
      ),
    );
  }
}
