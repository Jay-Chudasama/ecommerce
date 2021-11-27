import 'package:ecommerce/models/my_coupon_model.dart';

abstract class CouponsState{}

class CouponsInitial extends CouponsState{}
class CouponsLoading extends CouponsState{}
class CouponsLoaded extends CouponsState{
  List<MyCouponModel> coupons;

  CouponsLoaded(this.coupons);
}
class CouponsLoadingFailed extends CouponsState{
  String message;

  CouponsLoadingFailed(this.message);
}