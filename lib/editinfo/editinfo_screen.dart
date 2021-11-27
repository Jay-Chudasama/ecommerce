import 'package:ecommerce/editinfo/editinfo_cubit.dart';
import 'package:ecommerce/editinfo/editinfo_state.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/otp/otp_cubit.dart';
import 'package:ecommerce/registration/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

class EditInfoScreen extends StatelessWidget {
  late String _name, _email, _phone, _password;
  late AccountState _accountState;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _accountState = BlocProvider.of<AccountBloc>(context).state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<EditInfoCubit, EditInfoState>(
              listener: (context, state) {
                if(state is EditInfoFailed){
                    if (state.message == UNAUTHENTICATED_USER) {
                      BlocProvider.of<AuthCubit>(context).removeToken();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      ///force logout
                  }
                }
                if(state is EditInfoOtpRequested){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => OtpCubit(),
                        child: OtpScreen(
                          _email,
                          _phone,
                          _name,
                          _password,onlyVerify: true,
                        ),
                      ))).then((verified){
                        if(verified==true){
                          BlocProvider.of<EditInfoCubit>(context).updateInfo(_email, _phone, _name, _password);
                        }
                  });
                }
                if(state is EditInfoSubmitted){
                  BlocProvider.of<AccountBloc>(context).add(UpdateInfo(_email, _phone, _name));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Info Updated Successfully!"),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _emailField(
                          !(state is EditInfoSubmitting),
                          state is EditInfoFailed
                              ? state.message == 'email_exists'
                              ? "Already exists!"
                              : null
                              : null),
                      SizedBox(
                        height: 24,
                      ),
                      _phoneField(
                          !(state is EditInfoSubmitting),
                          state is EditInfoFailed
                              ? state.message == 'phone_exists'
                              ? "Already exists!"
                              : null
                              : null),
                      SizedBox(
                        height: 24,
                      ),
                      _nameField(  !(state is EditInfoSubmitting)),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Password is mandatory in order to update changes.',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _passwordField(
                          !(state is EditInfoSubmitting),
                          state is EditInfoFailed
                              ? state.message == 'incorrect_password'
                              ? "Incorrect Password!"
                              : null
                              : null),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed:(state is EditInfoSubmitting)
                              ? null
                              :  () {
                            if (formKey.currentState!.validate()) {
                              if(_phone==_accountState.userdata.phone){
                                BlocProvider.of<EditInfoCubit>(context).updateInfo(_email, _phone, _name, _password);
                              }else{
                                BlocProvider.of<EditInfoCubit>(context).requestUpdateOtp(_phone,_password);
                              }
                            }
                          },
                          child:  (state is EditInfoSubmitting)
                              ? SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                            width: 25,
                            height: 25,
                          )
                              : Text(
                            'Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _emailField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      validator: (value) {
        if (!RegExp(EMAIL_REGEX).hasMatch(value!)) {
          return "Please enter a valid Email Address!";
        }
        _email = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14),
      initialValue: _accountState.userdata.email,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorText: error,
        errorStyle: TextStyle(height: 1),
        hintText: 'Enter your Email Address.',
        fillColor: Colors.white,
        filled: true,
        labelText: 'Email Address',
        suffixIcon: const Icon(
          Icons.email,
        ),
      ),
    );
  }

  Widget _phoneField(enabled, error) {
    return TextFormField(
      maxLength: 10,
      enabled: enabled,
      validator: (value) {
        if (value!.length != 10) {
          return "Please enter a valid Phone number!";
        }
        _phone = value;
      },
      style: TextStyle(fontSize: 14),
      initialValue: _accountState.userdata.phone,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        hintText: 'Enter your Phone no.',
        errorBorder: ERROR_BORDER,
        errorText: error,
        errorStyle: TextStyle(height: 1),
        labelText: 'Phone',
        fillColor: Colors.white,
        filled: true,
        counterText: "",
        suffixIcon: const Icon(
          Icons.smartphone,
        ),
      ),
    );
  }

  Widget _nameField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      initialValue: _accountState.userdata.fullname,
      validator: (value) {
        if (value!.length <= 1) {
          return "Please enter a valid Name!";
        }
        _name = value;
      },
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        hintText: 'Enter your name',
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Fullname',
        suffixIcon: const Icon(
          Icons.person,
        ),
      ),
    );
  }

  Widget _passwordField(enabled,error) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      validator: (value) {
        if (value!=null && value.isEmpty) {
          return "Required!";
        }
        _password = value!;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        hintText: 'Password',
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        errorText: error,
        labelText: 'Password',
        suffixIcon: const Icon(
          Icons.lock,
        ),
      ),
    );
  }
}
