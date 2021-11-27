import 'package:ecommerce/home/fragments/cart/cart_fragment.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart",style: TextStyle(color: Colors.white),),),
      body: CartFragment(),
    );
  }
}
