import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'newbankaccount_bloc.dart';
import 'newbankaccount_event.dart';
import 'newbankaccount_state.dart';

class NewBankAccountScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  PayoutBeneficiaryModel bankAccount = PayoutBeneficiaryModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Bank Account"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: BlocConsumer<NewBankAccountBloc, NewBankAccountState>(
            listener: (context, state) {
              if(state is PincodeValidatedForBank){
                bankAccount.state = state.state;
                context.read<NewBankAccountBloc>().add(AddNewBankAccount(bankAccount));
              }
              if(state is NewBankAccountSubmitted){
                BlocProvider.of<AccountBloc>(context).add(AddBene(state.bankAccount));
                Navigator.pop(context);
              }
              if(state is InvalidPincodeForBank){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
              if (state is NewBankAccountFailed) {
                if (state.message == UNAUTHENTICATED_USER) {
                  BlocProvider.of<AuthCubit>(context).removeToken();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ///force logout
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
                }
              }

            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Center(
                        child: Text("NOTE: This bank details are only used for refund purpose.")),
                    SizedBox(
                      height: 16,
                    ),
                    _nameField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    _phoneField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    _accountField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    _ifscField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    _addressField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    _emailField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    _cityField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting)),
                    SizedBox(height: 16,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _pincodeField(!(state is ValidatingPincodeForBank) && !(state is NewBankAccountSubmitting),state is InvalidPincodeForBank?state.message:null)),
                        SizedBox(width: 16,),
                        Expanded(child: _stateField(state)),
                      ],
                    ),

                    SizedBox(height: 36,),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                )),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 50))),
                        onPressed: (state is NewBankAccountSubmitting || state is ValidatingPincodeForBank)
                            ? null
                            : () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<NewBankAccountBloc>(context).add(ValidatePincodeForBank(bankAccount.pincode!));
                          }
                        },
                        child: (state is NewBankAccountSubmitting || state is ValidatingPincodeForBank)
                            ? SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                          width: 25,
                          height: 25,
                        )
                            : Text(
                          'Submit',
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
        bankAccount.city = value;
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
        labelText: 'City',
      ),
    );
  }

  Widget _addressField(enabled) {
    return TextFormField(
      enabled: enabled,
      maxLines: 3,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        bankAccount.address1 = value;
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
        labelText: 'Address',
      ),
    );
  }

  Widget _accountField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        bankAccount.bankAccount = value;
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
        labelText: 'Bank Account No.',
      ),
    );
  }

  Widget _pincodeField(enabled,error) {
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
        bankAccount.pincode = int.parse(value);
      },
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
        bankAccount.state = value;
      },
      initialValue: state is PincodeValidatedForBank?state.state:bankAccount.state,
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
        labelText: state is PincodeValidatedForBank?state.state:"State",
      ),
    );
  }


  Widget _emailField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      validator: (value) {
        if (!RegExp(EMAIL_REGEX).hasMatch(value!)) {
          return "Please enter a valid Email Address!";
        }
        bankAccount.email = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        hintText: 'Enter your Email Address.',
        fillColor: Colors.white,
        filled: true,
        labelText: 'Email Address',

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
        bankAccount.name = value;
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
        labelText: 'Name',
      ),
    );
  }

  Widget _phoneField(enabled) {
    return TextFormField(
      maxLength: 10,
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],validator: (value) {
      if (value!.isEmpty) {
        return "Required!";
      }
      if (value.length != 10) {
        return "Please enter a valid Phone number!";
      }
      bankAccount.phone = value;
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
        labelText: 'Phone no.',
      ),
    );
  }

  Widget _ifscField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      validator: (value) {
      if (value!.isEmpty) {
        return "Required!";
      }
      bankAccount.ifsc = value;
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
        labelText: 'IFSC',
      ),
    );
  }
}
