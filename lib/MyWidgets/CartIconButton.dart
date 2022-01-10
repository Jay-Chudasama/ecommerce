import 'package:badges/badges.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartIconButton extends StatelessWidget {
  Color color = Colors.white;
  void Function()? onPressed;


  CartIconButton({required this.onPressed,this.color=Colors.white});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountBloc, AccountState, int>(selector: (state) {
      return state.userdata.cart!.length;
    }, builder: (context, state) {
      return IconButton(
          onPressed: onPressed,
          icon: Badge(
              showBadge: state > 0,
              badgeColor: Colors.pink,
              badgeContent: Text(
                state.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              animationType: BadgeAnimationType.scale,
              child: Icon(
                FontAwesomeIcons.shoppingBag,
                color: color,
              )));
    });
  }
}
