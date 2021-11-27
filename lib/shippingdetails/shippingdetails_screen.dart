import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:ecommerce/MyWidgets/AddressItem.dart';
import 'package:ecommerce/MyWidgets/AddressList.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/cart/cart_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_state.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/newaddress/newaddress_bloc.dart';
import 'package:ecommerce/newaddress/newaddress_screen.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/shippingdetails/transaction_cubit.dart';
import 'package:ecommerce/shippingdetails/transaction_state.dart';
import 'package:ecommerce/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class ShippingDetailsScreen extends StatefulWidget {
  CartTotals cartTotals;
  bool cod = false;

  ShippingDetailsScreen(this.cartTotals);

  @override
  _ShippingDetailsScreenState createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionUpdated) {
          if ((state is TransactionUpdated && state.status == 'SUCCESS') ||
              (state is TransactionUpdated &&
                  widget.cod &&
                  state.status == 'PENDING')) {
            BlocProvider.of<CartBloc>(context)
                .add(RemoveOrderedProducts(widget.cartTotals));
            BlocProvider.of<AccountBloc>(context)
                .add(RemovedOrderedProductsUserCart(widget.cartTotals));
          }
        }
      },
      builder: (context, state) {
        if ((state is TransactionUpdated && state.status == 'SUCCESS') ||
            (state is TransactionUpdated &&
                widget.cod &&
                state.status == 'PENDING')) {
          UserModel userdata =
              BlocProvider.of<AccountBloc>(context).state.userdata;
          return Scaffold(
              body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Order Placed Successfully',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Image.asset(
                      "assets/images/order_confirmed.png",
                      width: 160,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Thank You',
                      style: TextStyle(fontSize: 32),
                    ),
                    Text(
                      userdata.fullname!,
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Your order has been placed successfully and will be delivered to the address shown below.",
                      textAlign: TextAlign.center,
                    ),
                    AddressItem(
                      userdata.selectedAddress!,
                      showcase: true,
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            )),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 50))),
                        child: Text(
                          'Continue Shopping',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          ));
        }

        if (state is TransactionUpdateFailed) {
          return Scaffold(
            appBar: AppBar(),
            body: FailureMessage(
              message: 'Failed To Update Your Transaction!',
            ),
          );
        }
        if (state is TransactionUpdating) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Updating Transaction...Please wait')
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Shipping Details"),
          ),
          body: BlocSelector<AccountBloc, AccountState, Selected_address?>(
            selector: (state) {
              return state.userdata.selectedAddress;
            },
            builder: (context, state) => Column(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    RoundedContainer(
                      margin: EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Image.asset(
                            "assets/images/address.png",
                            width: 120,
                          )),
                          SizedBox(
                            height: 16,
                          ),
                          if (state != null) ...[
                            Text(
                              state.name!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(state.flatNo! + ', ' + state.locality! + ','),
                            Text(
                              '(Landmark ${state.landmark!})',
                            ),
                            Text(
                              state.city!,
                            ),
                            Text(
                              state.state!,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Pincode ' + state.pincode.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Mobile no. ' + state.mobileNo!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (state.alternateNo!.isNotEmpty)
                              Text(
                                'Alternate no. ' +
                                    state.alternateNo!.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                          ElevatedButton(
                              onPressed: () {
                                _showAddresses(context);
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )),
                                  elevation: MaterialStateProperty.all(0),
                                  fixedSize: MaterialStateProperty.all(
                                      Size(double.maxFinite, 50))),
                              child: Text(
                                'Change or Add Address',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                    RoundedContainer(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Cash on delivery"),
                        subtitle: Text(
                          'It allows you to pay the order amount at the time of delivery.',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: widget.cod,
                        onChanged: widget.cartTotals.cod == false
                            ? null
                            : (newValue) {
                                setState(() {
                                  widget.cod = newValue!;
                                });
                              },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              if (BlocProvider.of<AccountBloc>(context)
                      .state
                      .userdata
                      .selectedAddress !=
                  null)
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: INPUT_BORDER_COLOR,
                          offset: Offset.zero,
                          blurRadius: 20,
                          spreadRadius: 0)
                    ],
                  ),
                  child: BlocConsumer<CartBloc, CartState>(
                    listener: (context, state) {
                      if (state is PaymentInitiationFailed) {
                        Navigator.of(context).pop();
                      }
                      if (state is PaymentInitiatedWithCoupon ||
                          state is PaymentInitiated) {
                        if (widget.cod) {
                          String orderId = state is PaymentInitiatedWithCoupon
                              ? state.orderId
                              : state is PaymentInitiated
                                  ? state.orderId
                                  : "";
                          int tx_amount = state is PaymentInitiatedWithCoupon
                              ? state.tx_amount
                              : state is PaymentInitiated
                                  ? state.tx_amount
                                  : 0;
                          var data;
                          data = {
                            'orderId': orderId,
                            'orderAmount': tx_amount.toString(),
                            'referenceId': "cash on delivery",
                            'txStatus': 'VOID',
                            'paymentMode': "COD",
                            'txMsg': "",
                            'txTime': "",
                            'signature': ""
                          };
                          BlocProvider.of<TransactionCubit>(context)
                              .updateOrderInfo(data);
                        } else {
                          _openGateway(state);
                        }
                      }
                    },
                    builder: (context, state) => ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder()),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 50))),
                        onPressed: (state is InitiatingPayment ||
                                state is InitiatingPaymentWithCoupon)
                            ? null
                            : () {
                                context.read<CartBloc>().add(InitiatePayment(
                                    widget.cartTotals,
                                    widget.cod ? "COD" : "PREPAID",
                                    BlocProvider.of<AccountBloc>(context)
                                        .state
                                        .userdata
                                        .selectedAddress!
                                        .id!));
                              },
                        child: (state is InitiatingPayment ||
                                state is InitiatingPaymentWithCoupon)
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                                width: 25,
                                height: 25,
                              )
                            : Text(
                                'PLACE ORDER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                  ),
                )
            ]),
          ),
        );
      },
    );
  }

  _showAddresses(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddressList();
      },
    );
  }

  _openGateway(var state) {
    UserModel userdata = BlocProvider.of<AccountBloc>(context).state.userdata;

    String stage = "TEST";
    String orderId = state.orderId;
    String orderAmount = state.tx_amount.toString();
    String tokenData = state.token;
    String customerName = userdata.fullname!;
    String orderCurrency = state.orderCurrency;
    String appId = state.appId;
    String customerPhone = userdata.phone!;
    String customerEmail = userdata.email!;
    String notifyUrl = "https://test.gocashfree.com/notify";
    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "notifyUrl": notifyUrl,
      "tokenData": tokenData,
      "color1": "#50bc86",
      "color2": "#ffffff"
    };
    print('done');
    CashfreePGSDK.doPayment(inputParams).then((value) {
      var data;
      if (value!['txStatus'] == 'SUCCESS') {
        data = {
          'orderId': value['orderId'],
          'orderAmount': value['orderAmount'],
          'referenceId': value['referenceId'],
          'txStatus': value['txStatus'],
          'paymentMode': value['paymentMode'],
          'txMsg': value['txMsg'],
          'txTime': value['txTime'],
          'signature': value['signature']
        };
      } else {
        data = {
          'orderId': orderId,
          'referenceId': value['referenceId'],
          'txStatus': value['txStatus'],
          'paymentMode': value['paymentMode'],
          'txMsg': value['txMsg'],
          'txTime': value['txTime'],
          'signature': value['signature']
        };
      }
      BlocProvider.of<TransactionCubit>(context).updateOrderInfo(data);
    });
  }
}
