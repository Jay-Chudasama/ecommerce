import 'package:ecommerce/registration/login/login_cubit.dart';
import 'package:ecommerce/registration/login/login_screen.dart';
import 'package:ecommerce/registration/otp/otp_cubit.dart';
import 'package:ecommerce/registration/otp/otp_screen.dart';
import 'package:ecommerce/registration/signup/signup_cubit.dart';
import 'package:ecommerce/registration/signup/signup_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class SignUpScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  late String _email;
  late String _phone;
  late String _name;
  late String _password;
  late String _confirmpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: BlocConsumer<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state is SignUpSuccess) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                            create: (context) => OtpCubit(),
                            child: OtpScreen(
                              _email,
                              _phone,
                              _name,
                              _password,
                            ),
                          )));
                }
                if (state is SignUpFailed) {
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
                    _emailField(
                        !(state is SignUpSubmitting),
                        state is SignUpFailed
                            ? state.message == 'email_exists'
                                ? "Already exists!"
                                : null
                            : null),
                    SizedBox(
                      height: 24,
                    ),
                    _phoneField(
                        !(state is SignUpSubmitting),
                        state is SignUpFailed
                            ? state.message == 'phone_exists'
                                ? "Already exists!"
                                : null
                            : null),
                    SizedBox(
                      height: 24,
                    ),
                    _nameField(!(state is SignUpSubmitting)),
                    SizedBox(
                      height: 24,
                    ),
                    _passwordField(!(state is SignUpSubmitting)),
                    SizedBox(
                      height: 24,
                    ),
                    _confirmpasswordField(!(state is SignUpSubmitting)),
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
                        onPressed: (state is SignUpSubmitting)
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<SignUpCubit>(context)
                                      .requestOtp(_email, _phone);
                                }
                              },
                        child: (state is SignUpSubmitting)
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                                width: 25,
                                height: 25,
                              )
                            : Text(
                                'Create Account',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                    SizedBox(height: 48),
                    TextButton(
                        onPressed: (state is SignUpSubmitting)
                            ? null
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<LoginCubit>(
                                            create: (context) => LoginCubit(),
                                            child: LoginScreen())));
                              },
                        child: Text(
                          "Already have an Account? Login.",
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
