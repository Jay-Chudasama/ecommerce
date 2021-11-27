import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CashOnDeliveryTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
        color: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'Cash on delivery',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12),
        ));
  }
}
