import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/MyWidgets/CartItem.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/cart/cart_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_state.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:ecommerce/shippingdetails/shippingdetails_screen.dart';
import 'package:ecommerce/shippingdetails/transaction_cubit.dart';
import 'package:ecommerce/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';

class CartFragment extends StatelessWidget {
  String _couponCode = "";
  final formKey = GlobalKey<FormState>();
  late CartTotals cartTotals;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }

        if (state is InvalidCoupon) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
        if (state is PaymentInitiationFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      builder: (context, state) {
        if (state is CartInitial) {
          context.read<CartBloc>().add(LoadCart());
        }

        if (state is CartLoadingFailed) {
          return FailureMessage(
            message: state.message,
            onRetry: () {
              context.read<CartBloc>().add(LoadCart());
            },
          );
        }

        if (state is CartLoaded) {
          cartTotals = CartTotals(state.cart);
          state.cart.sort((a,b)=>b.quantity!.compareTo(a.quantity!));
          if(state.cart.length == 0){
            return Container();
          }
          return Column(
            children: [
              Expanded(
                child: state.cart.length>0? ListView.builder(
                  itemBuilder: (context, index) {
                    return CartItem(state, index, cartTotals);
                  },
                  itemCount: state.cart.length + 1,
                ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,)),
              ),
              if (cartTotals.totalAmount > 0)
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(PRIMARY_SWATCH),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder()),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed: () {
                            if (state is CouponApplied) {
                              context.read<CartBloc>().add(RemoveCoupon());
                            } else {
                              _showCouponDialog(state, context,
                                  BlocProvider.of<CartBloc>(context));
                            }
                          },
                          child: Text(
                            state is CouponApplied
                                ? "REMOVE COUPON"
                                : "APPLY COUPON",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: state is CouponApplied
                                    ? Colors.red
                                    : PRIMARY_SWATCH),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder()),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<CartBloc>(context),
                                    child: BlocProvider<TransactionCubit>(
                                        create: (_) => TransactionCubit(),
                                        child: ShippingDetailsScreen(
                                            cartTotals)))));
                          },
                          child: Text(
                            "CONTINUE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return CartItem.shimmer();
          },
          itemCount: 10,
        );
      },
    );
  }

  void _showCouponDialog(state, context, CartBloc bloc) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) => BlocProvider.value(
              value: bloc,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: formKey,
                    child: BlocConsumer<CartBloc, CartState>(
                      listener: (context, state) {
                        if (state is CouponApplied) {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "APPLY COUPON",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _couponCodeField(!(state is ValidatingCoupon),
                              state is InvalidCoupon ? state.message : null),
                          SizedBox(
                            height: 16,
                          ),
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
                              onPressed: (state is ValidatingCoupon)
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        bloc.add(ApplyCoupon(_couponCode,
                                            cartTotals.totalAmount));
                                      }
                                    },
                              child: (state is ValidatingCoupon)
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                      width: 25,
                                      height: 25,
                                    )
                                  : Text(
                                      'Apply',
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
            )).then((value) {
      if (bloc.state is InvalidCoupon) {
        bloc.add(RemoveCoupon());
      }
    });
  }

  Widget _couponCodeField(enabled, error) {
    return TextFormField(
      enabled: enabled,
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.length <= 1) {
          return "Invalid Code";
        }
        _couponCode = value;
      },
      autofocus: true,
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        hintText: 'Coupon Code',
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        fillColor: Colors.white,
        errorText: error,
        filled: true,
        labelText: 'Coupon Code',
        suffixIcon: const Icon(
          FontAwesomeIcons.ticketAlt,
        ),
      ),
    );
  }
}
