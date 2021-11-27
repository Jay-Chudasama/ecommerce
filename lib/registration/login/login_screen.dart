import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/forgotpassword/forgotpassword_cubit.dart';
import 'package:ecommerce/registration/forgotpassword/forgotpassword_screen.dart';
import 'package:ecommerce/registration/login/login_cubit.dart';
import 'package:ecommerce/registration/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  late String email_phone;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  //// logged in
                  BlocProvider.of<AuthCubit>(context).loggedIn(state.token);
                  Navigator.pop(context);
                }
                if (state is LoginFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: 28),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    _emailphoneField(
                        !(state is LoginSubmitting),
                        state is LoginFailed
                            ? state.message == 'incorrect_password'
                                ? null
                                : state.message
                            : null),
                    SizedBox(
                      height: 24,
                    ),
                    _passwordField(
                        !(state is LoginSubmitting),
                        state is LoginFailed
                            ? state.message == 'incorrect_password'
                                ? "Incorrect Password!"
                                : null
                            : null),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<ForgotPasswordCubit>(
                                        create: (context) => ForgotPasswordCubit(),
                                        child: ForgotPasswordScreen())));

                          }
                          ,
                          child: Text('Forgot Password?',
                              style: TextStyle(fontSize: 12,height: 1))),
                    ),
                    SizedBox(height: 58),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            )),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 50))),
                        onPressed: (state is LoginSubmitting)
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<LoginCubit>(context)
                                      .login(email_phone, _password);
                                }
                              },
                        child: (state is LoginSubmitting)
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                                width: 25,
                                height: 25,
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                    SizedBox(height: 48),
                    TextButton(
                        onPressed: (state is LoginSubmitting)
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: Text(
                          "Don't have an Account? SignUp!",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ));
  }

  Widget _emailphoneField(enabled, error) {
    return TextFormField(
      enabled: enabled,
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length < 4) {
          return "Invalid Credentials!";
        }
        email_phone = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        errorText: error,
        errorStyle: TextStyle(height: 1),
        labelText: 'Email or Phone no.',
        fillColor: Colors.white,
        filled: true,
        counterText: "",
        suffixIcon: const Icon(
          Icons.account_circle,
        ),
      ),
    );
  }

  Widget _passwordField(enabled, error) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length < 8) {
          return "Incorrect Password!";
        }
        _password = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        errorText: error,
        filled: true,
        labelText: 'Password',
        suffixIcon: const Icon(
          Icons.lock,
        ),
      ),
    );
  }
}
