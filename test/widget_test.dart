// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ecommerce/newbankaccount/newbankaccount_repository.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/main.dart';

void main() {
  test("fasdfasdf", (){
    NewBankAccountRepository repository = NewBankAccountRepository();

    PayoutBeneficiaryModel account = PayoutBeneficiaryModel();
    account.bankAccount = "Fadsfasf";
    account.name = "Fadsfasf";
    account.phone = "Fadsfasf";
    account.email = "Fadsfasf";
    account.ifsc = "Fadsfasf";
    account.address1 = "Fadsfasf";
    account.city = "Fadsfasf";
    account.state = "Fadsfasf";
    account.pincode = 370110;

     repository.addNewBankAccount(account).then((res) {
       expect(res, true);
     }).catchError((e) {
      print(e);
    });
  });
}
