abstract class OrderDetailsEvent{}

class LoadOrderDetails extends OrderDetailsEvent {
  String id;

  LoadOrderDetails(this.id);
}

class CancelOrder extends OrderDetailsEvent {
  String id;
  String payout_details_id;

  CancelOrder(this.id, this.payout_details_id);
}