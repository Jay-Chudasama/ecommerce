import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/OrderItem.dart';
import 'package:ecommerce/home/fragments/orders/orders_bloc.dart';
import 'package:ecommerce/home/fragments/orders/orders_event.dart';
import 'package:ecommerce/home/fragments/orders/orders_event.dart';
import 'package:ecommerce/home/fragments/orders/orders_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class OrdersFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<OrdersBloc>(
      create: (_)=>OrdersBloc(),
      child: BlocConsumer<OrdersBloc, OrdersState>(
            builder: (context, state) {
              if (state is OrdersInitial) {
                BlocProvider.of<OrdersBloc>(context).add(LoadOrders());
              }

              if (state is OrdersLoadingFailed) {
                return FailureMessage(
                  message: state.message,
                  onRetry: () {
                    BlocProvider.of<OrdersBloc>(context)
                        .add(LoadOrders());
                  },
                );
              }
              if (state is OrdersLoaded ||
                  state is MoreOrdersLoadingFailed) {
                OrdersLoaded _loadedOrders =
                state is MoreOrdersLoadingFailed
                    ? state.loadedOrders
                    : state as OrdersLoaded;
                return _loadedOrders.orders.length>0? ListView.builder(
                  itemBuilder: (context, index) {
                    if (index < _loadedOrders.orders.length) {
                      // Show your info
                      return OrderItem(_loadedOrders,index);
                    } else {
                      if (state is MoreOrdersLoadingFailed) {
                        return FailureMessage(message: state.message, onRetry: null);
                      }
                      BlocProvider.of<OrdersBloc>(context)
                          .add(LoadMoreOrders());
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  itemCount: _loadedOrders.next != null
                      ? _loadedOrders.orders.length + 1
                      : _loadedOrders.orders.length,
                ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
              }

              return ListView.builder(itemBuilder: (context,index){
                return OrderItem.shimmer();
              },);
            }, listener: (context, state) {
          if (state is OrdersLoadingFailed) {
            if (state.message == UNAUTHENTICATED_USER) {
              BlocProvider.of<AuthCubit>(context).removeToken();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ///force logout
            }
          }
          if (state is MoreOrdersLoadingFailed) {
            if (state.message == UNAUTHENTICATED_USER) {
              BlocProvider.of<AuthCubit>(context).removeToken();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ///force logout
            }
          }
        }),
    );
  }
}
