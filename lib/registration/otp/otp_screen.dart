import 'dart:async';

import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/otp/otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import 'otp_cubit.dart';

class OtpScreen extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  final String _email;
  final String _phone;
  final String _name;
  final String _password;
  late String _otp;
  late bool onlyVerify;

  var timer;
  int time = 0;

  OtpScreen(this._email, this._phone, this._name, this._password,
      {this.onlyVerify = false});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: BlocConsumer<OtpCubit, OtpState>(
                listener: (context, state) {
                  if (state is OtpVerificationFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ));
                  }
                  if (state is OtpVerified) {
                    //// logged in
                    if (widget.onlyVerify) {
                      Navigator.pop(context,true);
                    } else {
                      BlocProvider.of<AuthCubit>(context).loggedIn(state.token);
                      Navigator.pop(context);
                    }
                  }
                },
                builder: (context, state) => Column(
                  children: [
                    Image.asset(
                      'assets/images/otp.png',
                      width: 150,
                    ),
                    Text(
                      'Phone Verification',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                        'A verification code has been successfully sent to your Phone no. ' +
                            widget._phone +
                            '.'),
                    SizedBox(
                      height: 16,
                    ),
                    _otpField(!(state is OtpVerifying),
                        state is OtpVerificationFailed ? state.message : null),
                    TextButton(
                        onPressed: widget.time != 0
                            ? null
                            : () {
                                BlocProvider.of<OtpCubit>(context)
                                    .resendOtp(phone: widget._phone);
                                startTimer();
                              },
                        child: Text(
                          widget.time != 0
                              ? "Wait for ${widget.time} seconds to resend"
                              : "RESEND",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 60,
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
                        onPressed: (state is OtpVerifying)
                            ? null
                            : () {
                                if (widget.formKey.currentState!.validate()) {
                                  if (widget.onlyVerify) {
                                    BlocProvider.of<OtpCubit>(context)
                                        .verifyUpdateOtp(
                                            phone: widget._phone,
                                            otp: widget._otp);
                                  } else {
                                    BlocProvider.of<OtpCubit>(context)
                                        .verifyOtp(
                                            email: widget._email,
                                            name: widget._name,
                                            password: widget._password,
                                            phone: widget._phone,
                                            otp: widget._otp);
                                  }
                                }
                              },
                        child: (state is OtpVerifying)
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

  void startTimer() {
    widget.time = 60;
    const oneSec = const Duration(seconds: 1);
    widget.timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.time == 0) {
          timer.cancel();
        } else {
          setState(() {
            widget.time = widget.time - 1;
          });
        }
      },
    );
  }

  Widget _otpField(enabled, error) {
    return TextFormField(
      maxLength: 6,
      enabled: enabled,
      obscureText: true,
      validator: (value) {
        if (value!.length != 6) {
          return "Invalid OTP!";
        }
        widget._otp = value;
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        hintText: 'Enter 6 digit verification code.',
        errorBorder: ERROR_BORDER,
        errorText: error,
        errorStyle: TextStyle(height: 1),
        labelText: 'Verification OTP',
        fillColor: Colors.white,
        filled: true,
        counterText: "",
        suffixIcon: const Icon(
          Icons.sms_rounded,
        ),
      ),
    );
  }
}
