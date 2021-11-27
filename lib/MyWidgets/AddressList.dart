import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/newaddress/newaddress_bloc.dart';
import 'package:ecommerce/newaddress/newaddress_screen.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'AddressItem.dart';

class AddressList extends StatelessWidget {

  late bool manage;


  AddressList({this.manage=false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>.value(
      value: BlocProvider.of<AccountBloc>(context),
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AddressesLoadingFailed) {
              if (state.message == UNAUTHENTICATED_USER) {
                BlocProvider.of<AuthCubit>(context).removeToken();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ///force logout
              }
            }
          },
          builder: (context, state) {
            if (state is AccountInitial) {
              if (state.myaddresses == null) {
                context.read<AccountBloc>().add(LoadMyAddresses());
              }
            }
            return Stack(children: [
              Column(
                children: [
                  Text(
                    manage?"My Addresses":"Select Address",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (state is AddressesLoading)
                    CircularProgressIndicator(),
                  if (state is AddressesLoaded)
                    Expanded(
                      child: state.myaddresses!.length>0? ListView.builder(
                        itemBuilder: (context, index) {
                          return AddressItem(state.myaddresses![index],manage: manage,);
                        },
                        itemCount: state.myaddresses!.length,
                      ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,)),
                    ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: PRIMARY_SWATCH,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => NewAddressBloc(),
                          child: NewAddressScreen(),
                        )));
                  },
                  child: Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.white,
                  ),
                ),
              )
            ]);
          },
        ),
      ),
    );
  }
}

