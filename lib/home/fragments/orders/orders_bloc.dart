import 'package:dio/dio.dart';
import 'package:ecommerce/home/fragments/orders/orders_event.dart';
import 'package:ecommerce/home/fragments/orders/orders_repository.dart';
import 'package:ecommerce/home/fragments/orders/orders_state.dart';
import 'package:ecommerce/models/orders_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersBloc extends Bloc<OrdersEvent,OrdersState>{
  OrdersBloc() : super(OrdersInitial());
  OrdersRepository _ordersRepository = OrdersRepository();

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async*{
    OrdersState newState;

    if (event is LoadOrders) {
      newState = OrdersLoading();
      yield newState;
      await _ordersRepository.loadOrders().then((response) {
        var data = response.data;
        List<OrdersModel> list = List.from(
            data['results'].map((json) => OrdersModel.fromJson(json)));
        newState = OrdersLoaded(
            data['count'], data['next'], data['previous'], list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = OrdersLoadingFailed(error.response!.data);
          } catch (e) {
            newState = OrdersLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                OrdersLoadingFailed("Please check your internet connection!");
          } else {
            newState = OrdersLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is LoadMoreOrders) {
      newState = state;
      OrdersLoaded oldstate = state as OrdersLoaded;
      ///same home.fragments.notification
      await _ordersRepository
          .loadMoreOrders(nextUrl: oldstate.next!)
          .then((response) {
        var data = response.data;
        List<OrdersModel> list = List.from(
            data['results'].map((json) => OrdersModel.fromJson(json)));
        oldstate.orders.addAll(list);
        newState = OrdersLoaded(data['count'], data['next'],
            data['previous'] ,oldstate.orders);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = MoreOrdersLoadingFailed(error.response!.data,oldstate);
          } catch (e) {
            newState = MoreOrdersLoadingFailed(error.response!.data['detail'],oldstate);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                MoreOrdersLoadingFailed("Please check your internet connection!",oldstate);
          } else {
            newState = MoreOrdersLoadingFailed(error.message,oldstate);
          }
        }
      });
      yield newState;
    }

  }


}