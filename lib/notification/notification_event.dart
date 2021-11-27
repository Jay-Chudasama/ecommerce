import 'package:ecommerce/models/notification_model.dart';

abstract class NotificationsEvent{}

class LoadNotifications extends NotificationsEvent{

  LoadNotifications();
}

class LoadMoreNotifications extends NotificationsEvent{
}

class AddNewNotification extends NotificationsEvent{
  NotificationModel notificationModel;

  AddNewNotification(this.notificationModel);
}