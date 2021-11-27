import 'package:ecommerce/MyWidgets/AddressItem.dart';
import 'package:ecommerce/MyWidgets/AddressList.dart';
import 'package:ecommerce/MyWidgets/BankAccountList.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/changepassword/changepassword_cubit.dart';
import 'package:ecommerce/changepassword/changepassword_screen.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/editinfo/editinfo_cubit.dart';
import 'package:ecommerce/editinfo/editinfo_screen.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountFragment extends StatefulWidget {

  @override
  _AccountFragmentState createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  bool logoutAll = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AccountBloc,AccountState>(
          builder:(context,state)=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              Text(
                state.userdata.fullname!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Phone",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              Text(
                state.userdata.phone.toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Email Address",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              Text(
                state.userdata.email!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(0),
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 50))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(create:(_)=>EditInfoCubit(),child: EditInfoScreen())));
                  },
                  child: Text(
                    'Edit Info',
                    style: TextStyle(
                        color: PRIMARY_SWATCH, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      elevation: MaterialStateProperty.all(0),
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 50))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(create:(_)=>ChangePasswordCubit(),child: ChangePasswordScreen())));
                  },
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 16,
              ),
              if(state.userdata.selectedAddress!=null)

                RoundedContainer(
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      AddressItem(
                        state.userdata.selectedAddress!,
                        showcase: true,
                      ),
                      Positioned(
                          right: 8,
                          top: 8,
                          child: TextButton(
                              onPressed: () {
                                _showAddresses(context);
                              },
                              child: Text(
                                "Manage Addresses",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )))
                    ],
                  )),
              SizedBox(
                height: 16,
              ),
              Text("To manage Bank accounts provided at the time of Refund.",style: TextStyle(fontSize: 12,color: Colors.blueGrey),),
              SizedBox(
                height: 8,
              ), ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      fixedSize:
                      MaterialStateProperty.all(Size(double.maxFinite, 50))),
                  onPressed: () {
                    _showBankAccounts(context,onConfirm: null);
                  },
                  child: Text(
                    'Manage Bank Accounts',
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  )),

              SizedBox(
                height: 50,
              ),
              CheckboxListTile(value: logoutAll, onChanged: (value){
              setState(() {
                logoutAll = !logoutAll;
              });
              },title: Text("Logout from all Devices.",style: TextStyle(fontSize: 12),),),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      fixedSize:
                      MaterialStateProperty.all(Size(double.maxFinite, 50))),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(

                        title: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.signOutAlt,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Logout",style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        content:
                        Text("Are you sure, do you want to logout?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('CANCEL',style:  TextStyle(color: Colors.grey),),
                          ),
                          TextButton(
                            onPressed: (){
                              BlocProvider.of<AuthCubit>(context).logout(logoutAll);

                            },
                            child: const Text('LOGOUT',style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAddresses(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddressList(manage: true,);
      },
    );
  }

  _showBankAccounts(context,{onConfirm}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BankAccountList(onConfirm);
      },
    );
  }
}
