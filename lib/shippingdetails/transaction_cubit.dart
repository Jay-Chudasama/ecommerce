import 'package:dio/dio.dart';
import 'package:ecommerce/shippingdetails/transaction_repository.dart';
import 'package:ecommerce/shippingdetails/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());
  TransactionRepository _transactionRepository = TransactionRepository();

  void updateOrderInfo(var data) {
    emit(TransactionUpdating());
    _transactionRepository
        .confirmTransaction(data)
        .then((response) {
emit(TransactionUpdated(data['txStatus']));
    })
        .catchError((value) {
      DioError error = value;

      if (error.type == DioErrorType.other) {
        emit(TransactionUpdateFailed("Please check your internet connection!"));
      } else {
        emit(TransactionUpdateFailed(error.message));
      }
    });
  }
}
