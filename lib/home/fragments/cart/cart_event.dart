import 'package:ecommerce/utils.dart';

import 'cart_state.dart';

abstract class CartEvent{}

class LoadCart extends CartEvent{}

class AddToCart extends CartEvent{
  late String id;

  AddToCart(this.id);

}

class RemoveFromCart extends CartEvent {
  late String id;

  RemoveFromCart(this.id);
}


class UpdateQuantity extends CartEvent{
  late String id;
  late int updatedQuantity;

  UpdateQuantity(this.id, this.updatedQuantity);
}

class ApplyCoupon extends CartEvent{
  late String code;
  late int totalAmt;

  ApplyCoupon(this.code, this.totalAmt);
}

class RemoveCoupon extends CartEvent{
}

class InitiatePayment extends CartEvent{
  late CartTotals cartTotals;
  late String paymentMode;
  late String addressId;

  InitiatePayment(this.cartTotals, this.paymentMode,this.addressId);
}

class RemoveOrderedProducts extends CartEvent{
  late CartTotals cartTotals;

  RemoveOrderedProducts(this.cartTotals);
}

