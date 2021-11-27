import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/MyWidgets/AddressItem.dart';
import 'package:ecommerce/MyWidgets/BankAccountItem.dart';
import 'package:ecommerce/MyWidgets/BankAccountList.dart';
import 'package:ecommerce/MyWidgets/CartItem.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/OrderDetialsWidget/MyReviewContainer.dart';
import 'package:ecommerce/MyWidgets/OrderDetialsWidget/StatusContainer.dart';
import 'package:ecommerce/MyWidgets/ProductDetailsWidget/ReviewsContainer.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/home/fragments/orders/orders_bloc.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/newaddress/newaddress_bloc.dart';
import 'package:ecommerce/newaddress/newaddress_screen.dart';
import 'package:ecommerce/newbankaccount/newbankaccount_bloc.dart';
import 'package:ecommerce/newbankaccount/newbankaccount_screen.dart';
import 'package:ecommerce/orderdetails/orderdetails_bloc.dart';
import 'package:ecommerce/orderdetails/orderdetails_event.dart';
import 'package:ecommerce/orderdetails/orderdetails_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class OrderDetailsScreen extends StatelessWidget {
  String review = "";
  late String id;
  CartTotals cartTotals = CartTotals([]);

  OrderDetailsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailsBloc>(
      create: (_) => OrderDetailsBloc(),
      child: BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
          listener: (context, state) {
        if (state is OrderDetailsLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
        if (state is OrderCancellationFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        }
      }, builder: (context, state) {
        if (state is OrderDetailsInitial) {
          context.read<OrderDetailsBloc>().add(LoadOrderDetails(id));
        }

        if (state is OrderDetailsLoadingFailed) {
          return FailureMessage(
            message: state.message,
            onRetry: () {
              context.read<OrderDetailsBloc>().add(LoadOrderDetails(id));
            },
          );
        }

        if (state is OrderDetailsLoaded) {
          cartTotals.itemTotal =
              state.details.productPrice! * state.details.quantity!;
          cartTotals.deliveryCharge = state.details.deliveryPrice!;
          cartTotals.discountAmt =
              cartTotals.itemTotal - state.details.txPrice!;
          cartTotals.totalAmount = state.details.txPrice!;
          cartTotals.itemCount = state.details.quantity!;

          return Scaffold(
            appBar: AppBar(
              title: Text("Order Details"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  RoundedContainer(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                  imageUrl: DOMAIN_URL +
                                      state.details.productOption!.image!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) => Icon(
                                        Icons.broken_image_sharp,
                                        color: Colors.grey,
                                      ))),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    state.details.productOption!.title!,
                                    style: TextStyle(fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "(${state.details.productOption!.option})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Qty : ${state.details.quantity.toString()}",
                                      ),
                                      Spacer(),
                                      Text(
                                        CURRENCY +
                                            state.details.productPrice
                                                .toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  StatusContainer(state),
                  if(!(state.details.status == 'CANCELLED' || state.details.status =='DELIVERED'))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            )),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 45))),
                        onPressed: state is CancellingOrder
                            ? null
                            : () {
                                _showBankAccounts(context,onConfirm: (selectedBankId) {
                                  BlocProvider.of<OrderDetailsBloc>(context)
                                      .add(CancelOrder(id, selectedBankId));
                                  Navigator.of(context).pop();
                                });
                              },
                        child: (state is CancellingOrder)
                            ? SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                          width: 25,
                          height: 25,
                        ):  Text(
                          'Cancel Order',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                  AddressItem(
                    state.details.order!.address!,
                    showcase: true,
                  ),
                  if (state.details.status == 'DELIVERED')
                    MyReviewContainer(state),
                  CartItem(null, 0, cartTotals),
                  RoundedContainer(
                      width: double.infinity,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              "Payment Mode : ${state.details.order!.paymentMode!}"),
                          Text(
                              "Transaction ID : ${state.details.order!.txId!}"),
                          Text(
                              "Order ID : ${state.details.order!.id!}"),
                        ],
                      ))
                ],
              ),
            ),
          );
        }

//        shimmer
        return Scaffold(
          appBar: AppBar(
            title: Text("Order Details"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                RoundedContainer(
                    margin: EdgeInsets.all(8),
                    child: ShimmerContainer(
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                                height: 100,
                                width: 100,
                              )),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(height: 20, color: Colors.white),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 20,
                                          width: 20,
                                          color: Colors.white),
                                      Spacer(),
                                      Container(
                                          height: 25,
                                          width: 40,
                                          color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                StatusContainer.shimmer(),
                AddressItem.shimmer(),
                CartItem.shimmer(
                  index: 0,
                )
              ],
            ),
          ),
        );
      }),
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
