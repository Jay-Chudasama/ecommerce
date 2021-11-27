import 'package:ecommerce/models/orders_model.dart';

abstract class OrdersState{}

class OrdersInitial extends OrdersState {}
class OrdersLoading extends OrdersState{}
class OrdersLoaded extends OrdersState{
  int count;
  String? next;
  String? previous;
  List<OrdersModel> orders;

  OrdersLoaded(this.count, this.next, this.previous, this.orders);
}
class OrdersLoadingFailed extends OrdersState{
  String message;

  OrdersLoadingFailed(this.message);
}

class MoreOrdersLoadingFailed extends OrdersState{
  String message;
  OrdersLoaded loadedOrders;

  MoreOrdersLoadingFailed(this.message, this.loadedOrders);
}