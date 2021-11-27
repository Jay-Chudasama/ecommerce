
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/NotificationItem.dart';
import 'package:ecommerce/notification/notification_bloc.dart';
import 'package:ecommerce/notification/notification_event.dart';
import 'package:ecommerce/notification/notification_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Notifications"),),
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsInitial) {
              BlocProvider.of<NotificationsBloc>(context).add(LoadNotifications());
            }

            if (state is NotificationsLoadingFailed) {
              return FailureMessage(
                message: state.message,
                onRetry: () {
                  BlocProvider.of<NotificationsBloc>(context)
                      .add(LoadNotifications());
                },
              );
            }
            if (state is NotificationsLoaded ||
                state is MoreNotificationsLoadingFailed) {
              NotificationsLoaded _loadedNotifications =
              state is MoreNotificationsLoadingFailed
                  ? state.loadedNotifications
                  : state as NotificationsLoaded;
              return _loadedNotifications.notifications.length > 0? ListView.builder(
                itemBuilder: (context, index) {
                  if (index < _loadedNotifications.notifications.length) {
                    // Show your info
                      return NotificationItem(_loadedNotifications.notifications[index]);
                  } else {
                    if (state is MoreNotificationsLoadingFailed) {
                      return FailureMessage(message: state.message, onRetry: null);
                    }
                    BlocProvider.of<NotificationsBloc>(context)
                        .add(LoadMoreNotifications());
                    return Center(child: CircularProgressIndicator());
                  }
                },
                itemCount: _loadedNotifications.next != null
                    ? _loadedNotifications.notifications.length + 1
                    : _loadedNotifications.notifications.length,
              ):
              Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
            }

            return ListView.builder(itemBuilder: (context,index){
              return NotificationItem.shimmer();
            },);
          }, listener: (context, state) {
        if (state is NotificationsLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
        if (state is MoreNotificationsLoadingFailed) {
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
