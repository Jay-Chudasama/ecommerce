import 'package:ecommerce/productdetails/StockOutCubit/StockState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockCubit extends Cubit<StockState>{
  StockCubit() : super(InStock(0));

  void stockAvailable(int quantity){
    emit(InStock(quantity));
  }

  void outOfStock(){
    emit(StockOut());
  }

}