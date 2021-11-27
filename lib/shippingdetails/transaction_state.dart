abstract class TransactionState {}

class TransactionInitial extends TransactionState{}

class TransactionUpdating extends TransactionState{}

class TransactionUpdated extends TransactionState{
  String status;

  TransactionUpdated(this.status);
}
class TransactionUpdateFailed extends TransactionState{

  String message;

  TransactionUpdateFailed(this.message);
}