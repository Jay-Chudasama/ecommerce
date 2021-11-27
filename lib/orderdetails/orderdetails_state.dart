import 'package:ecommerce/models/order_details_model.dart';

abstract class OrderDetailsState{}

class OrderDetailsInitial extends OrderDetailsState{}
class OrderDetailsLoading extends OrderDetailsState{}
class OrderDetailsLoaded extends OrderDetailsState{
  OrderDetailsModel details;

  OrderDetailsLoaded(this.details);
}
class OrderDetailsLoadingFailed extends OrderDetailsState{
  String message;

  OrderDetailsLoadingFailed(this.message);
}

class CancellingOrder extends OrderDetailsLoaded{
  CancellingOrder(OrderDetailsModel details) : super(details);
}


class OrderCancellationFailed extends OrderDetailsLoaded{
  String message;
  OrderCancellationFailed(this.message,OrderDetailsModel details) : super(details);
}