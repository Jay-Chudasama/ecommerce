import 'package:dio/dio.dart';
import 'package:ecommerce/models/order_details_model.dart';
import 'package:ecommerce/orderdetails/orderdetails_event.dart';
import 'package:ecommerce/orderdetails/orderdetails_repository.dart';
import 'package:ecommerce/orderdetails/orderdetails_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent,OrderDetailsState>{
  OrderDetailsBloc() : super(OrderDetailsInitial());
  OrderDetailsRepository _orderDetailsRepository= OrderDetailsRepository();

  @override
  Stream<OrderDetailsState> mapEventToState(OrderDetailsEvent event) async*{
    OrderDetailsState newState;
    if(event is LoadOrderDetails){
      newState = OrderDetailsLoading();
      yield newState;
      await _orderDetailsRepository.loadOrder(event.id).then((response) {
        newState =
            OrderDetailsLoaded(OrderDetailsModel.fromJson(response.data));
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = OrderDetailsLoadingFailed(error.response!.data);
          } catch (e) {
            newState = OrderDetailsLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                OrderDetailsLoadingFailed("Please check your internet connection!");
          } else {
            newState = OrderDetailsLoadingFailed(error.message);
          }
        }
      });
      yield newState;

    }


    if(event is CancelOrder){
      OrderDetailsLoaded oldstate = state as OrderDetailsLoaded;
      newState = CancellingOrder(oldstate.details);
      yield newState;
      await _orderDetailsRepository.cancelOrder(event.id, event.payout_details_id).then((response) {
        oldstate.details.status = 'CANCELLED';
        oldstate.details.cancelledAt = response.data['cancelled_at'];
        newState = OrderDetailsLoaded(oldstate.details);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = OrderCancellationFailed(error.response!.data,oldstate.details);
          } catch (e) {
            newState = OrderCancellationFailed(error.response!.data['detail'],oldstate.details);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                OrderCancellationFailed("Please check your internet connection!",oldstate.details);
          } else {
            newState = OrderCancellationFailed(error.message,oldstate.details);
          }
        }
      });
      yield newState;
    }

  }

}