import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticatingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {

            if(state is Authenticating){
              return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('Logging In...')
                    ],
                  )
              );
            }
            return  FailureMessage(message:( state as AuthenticationFailed).message,onRetry: (){
              BlocProvider.of<AuthCubit>(context).authenticate();
            }, );
          }),
    );
  }
}
