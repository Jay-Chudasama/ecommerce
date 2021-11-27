import 'package:dio/dio.dart';
import 'package:ecommerce/models/notification_model.dart';
import 'package:ecommerce/notification/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent,NotificationsState>{
  NotificationsBloc() : super(NotificationsInitial());
  NotificationRepository _notificationsRepository = NotificationRepository();

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async*{
    NotificationsState newState;

    if (event is LoadNotifications) {
      newState = NotificationsLoading();
      yield newState;
      await _notificationsRepository.loadNotifications().then((response) {
        var data = response.data;
        List<NotificationModel> list = List.from(
            data['results'].map((json) => NotificationModel.fromJson(json)));
        newState = NotificationsLoaded(
            data['count'], data['next'], data['previous'], list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = NotificationsLoadingFailed(error.response!.data);
          } catch (e) {
            newState = NotificationsLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                NotificationsLoadingFailed("Please check your internet connection!");
          } else {
            newState = NotificationsLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is LoadMoreNotifications) {
      newState = state;
      NotificationsLoaded oldstate = state as NotificationsLoaded;
      ///same home.fragments.notification
      await _notificationsRepository
          .loadMoreNotifications(nextUrl: oldstate.next!)
          .then((response) {
        var data = response.data;
        List<NotificationModel> list = List.from(
            data['results'].map((json) => NotificationModel.fromJson(json)));
        oldstate.notifications.addAll(list);
        newState = NotificationsLoaded(data['count'], data['next'],
            data['previous'] ,oldstate.notifications);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = MoreNotificationsLoadingFailed(error.response!.data,oldstate);
          } catch (e) {
            newState = MoreNotificationsLoadingFailed(error.response!.data['detail'],oldstate);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                MoreNotificationsLoadingFailed("Please check your internet connection!",oldstate);
          } else {
            newState = MoreNotificationsLoadingFailed(error.message,oldstate);
          }
        }
      });
      yield newState;
    }else if(event is AddNewNotification){
      NotificationsLoaded oldState = state as NotificationsLoaded;
      oldState.notifications.insert(0,event.notificationModel);
      if(oldState.next!=null) {
        oldState.notifications.removeLast();
      }
      yield NotificationsLoaded(oldState.count, oldState.next, oldState.previous, oldState.notifications);
    }

  }


}