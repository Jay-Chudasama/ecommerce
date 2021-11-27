import 'package:ecommerce/models/notification_model.dart';
import 'package:ecommerce/models/orders_model.dart';

abstract class NotificationsState{}

class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState{}
class NotificationsLoaded extends NotificationsState{
  int count;
  String? next;
  String? previous;
  List<NotificationModel> notifications;

  NotificationsLoaded(this.count, this.next, this.previous, this.notifications);
}
class NotificationsLoadingFailed extends NotificationsState{
  String message;

  NotificationsLoadingFailed(this.message);
}

class MoreNotificationsLoadingFailed extends NotificationsState{
  String message;
  NotificationsLoaded loadedNotifications;

  MoreNotificationsLoadingFailed(this.message, this.loadedNotifications);
}