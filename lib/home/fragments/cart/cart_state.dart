import 'package:ecommerce/models/cart_model.dart';

abstract class CartState{}

class CartInitial extends CartState{}
class CartLoading extends CartState{}
class CartLoaded extends CartState{
  List<CartModel> cart;

  CartLoaded(this.cart);
}

class CouponApplied extends CartLoaded{
  late int discountAmt;
  late String couponCode;
  CouponApplied(this.discountAmt,this.couponCode,List<CartModel> cart) : super(cart);

}

class ValidatingCoupon extends CartLoaded{
  ValidatingCoupon(List<CartModel> cart) : super(cart);
}

class InvalidCoupon extends CartLoaded{
  String message;

  InvalidCoupon(this.message,List<CartModel> cart) : super(cart);
}
class CartLoadingFailed extends CartState{
  String message;

  CartLoadingFailed(this.message);
}

class InitiatingPayment extends CartLoaded{
  InitiatingPayment(List<CartModel> cart) : super(cart);
}

class InitiatingPaymentWithCoupon extends CouponApplied{
  InitiatingPaymentWithCoupon(int discountAmt, String couponCode, List<CartModel> cart) : super(discountAmt, couponCode, cart);
}

class PaymentInitiationFailed extends CartLoaded{
  String message;

  PaymentInitiationFailed(this.message,List<CartModel> cart) : super(cart);

}

class PaymentInitiated extends CartLoaded{
  late String token,orderId,appId,orderCurrency;
  late int tx_amount;

  PaymentInitiated(
      this.token, this.orderId, this.appId, this.orderCurrency, this.tx_amount,List<CartModel> cart) : super(cart);
}

class PaymentInitiatedWithCoupon extends CouponApplied{
  late String token,orderId,appId,orderCurrency;
  late int tx_amount;

  PaymentInitiatedWithCoupon(
      this.token, this.orderId, this.appId, this.orderCurrency, this.tx_amount,int discountAmt, String couponCode, List<CartModel> cart) : super(discountAmt, couponCode, cart);

}

