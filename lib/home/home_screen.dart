import 'package:badges/badges.dart';
import 'package:ecommerce/MyWidgets/CartIconButton.dart';
import 'package:ecommerce/MyWidgets/NotificationIconButton.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_fragment.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/home/fragments/cart/cart_fragment.dart';
import 'package:ecommerce/home/fragments/coupons/coupons_fragment.dart';
import 'package:ecommerce/home/fragments/home/home_fragment.dart';
import 'package:ecommerce/home/fragments/orders/orders_fragment.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_fragment.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/notification/notification_bloc.dart';
import 'package:ecommerce/notification/notification_screen.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../registration/authentication/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fragments/account/account_event.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Home", FontAwesomeIcons.home),
    DrawerItem("My Orders", FontAwesomeIcons.box),
    DrawerItem("My Coupons", FontAwesomeIcons.ticketAlt),
    DrawerItem("My Bag", FontAwesomeIcons.shoppingBag),
    DrawerItem("My Wishlist", FontAwesomeIcons.solidHeart),
    DrawerItem("My Account", FontAwesomeIcons.solidUserCircle),
  ];

  final HomeFragment _homeFragment = HomeFragment();
  final WishlistFragment _wishlistFragment = WishlistFragment();
  final CartFragment _cartFragment = CartFragment();
  final OrdersFragment _ordersFragment = OrdersFragment();
  final CouponsFragment _couponsFragment = CouponsFragment();
  final AccountFragment _accountFragment = AccountFragment();

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;
  final double iconSize = 40;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: _selectedDrawerIndex == 0
            ? [
                NotificationIconButton(onPressed: () {
                  BlocProvider.of<AccountBloc>(context).add(NotificationsReaded());
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<NotificationsBloc>(context),
                            child: NotificationsScreen(),
                          )));
                }),
                CartIconButton(onPressed: () {
                  setState(() => _selectedDrawerIndex = 3);
                }),
              ]
            : [],
        titleSpacing: 0,
        shadowColor:
            _selectedDrawerIndex == 0 ? Colors.transparent : INPUT_BORDER_COLOR,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white, // add custom icons also
          ),
        ),
        title: _selectedDrawerIndex == 0
            ? Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: iconSize,
                    width: iconSize,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'FOODMALL',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              )
            : Text(
                widget.drawerItems[_selectedDrawerIndex].title,
                style: TextStyle(color: Colors.white),
              ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.white, //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: _createDrawerOptions(),
            ),
          ),
        ),
      ),
      body: _getDrawerItemFragment(_selectedDrawerIndex),
    );
  }

  _createDrawerOptions() {
    var drawerOptions = <Widget>[
      //Drawer Header
      BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) => UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          accountName: Text(
            state.userdata.fullname!,
            style: TextStyle(
                color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          accountEmail: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.userdata.email!,
              ),
              Text(
                state.userdata.phone!,
              ),
            ],
          ),
        ),
      )
    ];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      ///adding Drawer list items
      var d = widget.drawerItems[i];
      drawerOptions.add(Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: ListTile(
          leading: FaIcon(
            d.icon,
          ),
          title: Text(
            d.title,
            style: TextStyle(fontSize: 16),
          ),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        ),
      ));
    }

    return drawerOptions;
  }

  _getDrawerItemFragment(int pos) {
    switch (pos) {
      case 0:
        return widget._homeFragment;
      case 1:
        return widget._ordersFragment;
      case 2:
        return widget._couponsFragment;
      case 3:
        return widget._cartFragment;
      case 4:
        return widget._wishlistFragment;
      case 5:
        return widget._accountFragment;

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }
}
