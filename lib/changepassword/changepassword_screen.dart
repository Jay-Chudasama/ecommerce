import 'package:ecommerce/changepassword/changepassword_cubit.dart';
import 'package:ecommerce/changepassword/changepassword_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  late String oldpassword, _password, _confirmpassword;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: BlocConsumer<ChangePasswordCubit,ChangePasswordState>(
            listener: (context,state){
              if(state is ChangePasswordFailed){
                if (state.message == UNAUTHENTICATED_USER) {
                  BlocProvider.of<AuthCubit>(context).removeToken();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ///force logout
                }
              }
              if(state is ChangePasswordSubmitted){
                  BlocProvider.of<AuthCubit>(context).removeToken();
                  Navigator.of(context).pop();
                }
            }
            ,
            builder:(context,state)=> Form(
              key: formKey,
              child: Column(
                children: [
                  _oldPasswordField(
                      !(state is ChangePasswordSubmitting),
                      state is ChangePasswordFailed
                          ? state.message == 'incorrect_password'
                          ? "Incorrect Password!"
                          : null
                          : null),
                  SizedBox(
                    height: 24,
                  ),
                  _passwordField(
                      !(state is ChangePasswordSubmitting),
                       ),
                  SizedBox(
                    height: 24,
                  ),
                  _confirmpasswordField(
                      !(state is ChangePasswordSubmitting),
                   ),
                  SizedBox(
                    height: 50,
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
                      onPressed:(state is ChangePasswordSubmitting)
                          ? null
                          :  () {
                        if (formKey.currentState!.validate()) {
                            BlocProvider.of<ChangePasswordCubit>(context).changePassword(oldpassword,_password);
                        }
                      },
                      child:  (state is ChangePasswordSubmitting)
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
                      )),],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _oldPasswordField(enabled,error) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required!";
        }
        oldpassword = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        hintText: 'Old Password',
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        errorText: error,
        filled: true,
        labelText: 'Old Password',
        suffixIcon: const Icon(
          Icons.lock,
        ),
      ),
    );
  }

  Widget _passwordField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      validator: (value) {
        if (value!.length < 8) {
          return "At least 8 characters!";
        }
        _password = value;
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
        labelText: 'Password',
        suffixIcon: const Icon(
          Icons.lock,
        ),
      ),
    );
  }

  Widget _confirmpasswordField(enabled) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      validator: (value) {
        if (value != _password) {
          return "Password mismatched!";
        }
        _confirmpassword = value!;
      },
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: 'Confirm Password',
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        filled: true,
        labelText: ' Confirm Password',
        suffixIcon: const Icon(
          Icons.lock,
        ),
      ),
    );
  }
}
