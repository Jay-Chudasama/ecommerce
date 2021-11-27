import 'package:ecommerce/registration/forgotpassword/forgotpassword_cubit.dart';
import 'package:ecommerce/registration/forgotpassword/forgotpassword_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  late String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ));
                  }

                },
                builder: (context, state) => Column(
                  children: [
                    Image.asset(
                      state is ForgotPasswordSuccess
                          ? 'assets/images/inbox.png'
                          : 'assets/images/forgot_password.png',
                      width: 90,
                    ),
                    Text(
                      state is ForgotPasswordSuccess
                          ? "Check your Inbox!"
                          : 'Forgot Password?',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(state is ForgotPasswordSuccess
                        ? "Password reset email has been sent successfully to your registered email address, so please check your inbox to set your new password."
                        : "Don't worry we just need your registered Email address and its done."),
                    SizedBox(
                      height: 46,
                    ),
                    _emailField(
                        !(state is ForgotPasswordSubmitting) &&
                            !(state is ForgotPasswordSuccess),
                        state is ForgotPasswordFailed ? state.message : null),
                    SizedBox(
                      height: 80,
                    ),
                    if (!(state is ForgotPasswordSuccess))
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
                          onPressed: (state is ForgotPasswordSubmitting)
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<ForgotPasswordCubit>(
                                            context)
                                        .resetPassword(_email);
                                  }
                                },
                          child: (state is ForgotPasswordSubmitting)
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                  width: 25,
                                  height: 25,
                                )
                              : Text(
                                  'Verify',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                  ],
                ),
              ),
            ),
          ),
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
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorText: error,
        errorStyle: TextStyle(height: 1),
        hintText: 'Enter your registered email address.',
        fillColor: Colors.white,
        filled: true,
        labelText: 'Registered Email Address',
        suffixIcon: const Icon(
          Icons.email,
        ),
      ),
    );
  }
}
