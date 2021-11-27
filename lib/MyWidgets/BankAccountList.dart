import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/newbankaccount/newbankaccount_bloc.dart';
import 'package:ecommerce/newbankaccount/newbankaccount_screen.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'BankAccountItem.dart';

class BankAccountList extends StatelessWidget {

  var onConfirm;
  var selectedBankId;


  BankAccountList(this.onConfirm);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>.value(
      value: BlocProvider.of<AccountBloc>(context),
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is BenesLoadingFailed) {
              if (state.message == UNAUTHENTICATED_USER) {
                BlocProvider.of<AuthCubit>(context).removeToken();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ///force logout
              }
            }
          },
          builder: (context, state) {
            if (state is AccountInitial) {
              if (state.myBankAccounts == null) {
                context.read<AccountBloc>().add(LoadMyBenes());
              }
            }
            return Stack(children: [
              Column(
                children: [
                  Center(
                    child: Text(
                      onConfirm!=null?"Select Bank Account":"My Bank Accounts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  if (state is BenesLoading) CircularProgressIndicator(),
                  if (state is BenesLoaded)
                    Expanded(
                      child: state.myBankAccounts!.length>0?ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                selectedBankId =
                                    state.myBankAccounts![index].id;
                                context
                                    .read<AccountBloc>()
                                    .add(UpdateSelectedBene());
                              },
                              child: BankAccountItem(
                                state.myBankAccounts![index],
                                selected: selectedBankId ==
                                    state.myBankAccounts![index].id,manage: onConfirm==null,
                              ));
                        },
                        itemCount: state.myBankAccounts!.length,
                      ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,)),
                    ),
                  if(onConfirm!=null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: selectedBankId == null
                            ? null
                            : ()=>onConfirm(selectedBankId),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                )),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 45))),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  )
                ],
              ),
              Positioned(
                bottom: onConfirm!=null?70:16,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: PRIMARY_SWATCH,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => NewBankAccountBloc(),
                          child: NewBankAccountScreen(),
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
