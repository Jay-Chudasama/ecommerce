import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BankAccountItem extends StatelessWidget {
  late PayoutBeneficiaryModel model;

  bool selected ,manage;

  BankAccountItem(this.model,{this.selected=false,this.manage=false});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: selected && !manage?Colors.blueGrey.shade50:Colors.white,
      margin: EdgeInsets.all(8),
        child: Column(
      children: [
       _row(context,"Bank Account No.",model.bankAccount!,show: manage),
        _row(context,"IFSC",model.ifsc!),
        _row(context,"NAME",model.name!),
        _row(context,"EMAIL",model.email!),
        _row(context,"PHONE",model.phone!),
        _row(context,"ADDRESS",model.address1!),
        _row(context,"CITY",model.city!),
        _row(context,"PINCODE",model.pincode!.toString()),
        _row(context,"STATE",model.state!),
      ],
    ));
  }

  _row(context,key,value,{show=false}){
    return  Row(
      children: [
        Expanded(flex:1,child: Text(key,style: TextStyle(fontWeight: FontWeight.bold),)),
        Expanded(flex:2,child: Text(value)),
        SizedBox(width: 50,child: show?IconButton(icon: Icon(FontAwesomeIcons.trash,color: Colors.red,), onPressed: () {
BlocProvider.of<AccountBloc>(context).add(DeleteBene(model.id!));
        },):null)
      ],
    );
  }
}
