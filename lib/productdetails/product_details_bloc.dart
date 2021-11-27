import 'package:dio/dio.dart';
import 'package:ecommerce/models/product_details_model.dart';
import 'package:ecommerce/productdetails/product_details_event.dart';
import 'package:ecommerce/productdetails/product_details_repository.dart';
import 'package:ecommerce/productdetails/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailBloc extends Bloc<ProductDetailsEvent,ProductDetailState>{
  ProductDetailBloc() : super(ProductDetailInitial());

  ProductDetailsRepository _productDetailsRepository = ProductDetailsRepository();

  @override
  Stream<ProductDetailState> mapEventToState(ProductDetailsEvent event) async*{
    ProductDetailState newState;
    if(event is LoadProduct){
      newState = ProductDetailLoading();
      yield newState;
      await _productDetailsRepository.loadProduct(id: event.id).then((response){
        newState =  ProductDetailLoaded(ProductDetailsModel.fromJson(response.data));
      }).catchError((value){
        DioError error = value;
        if (error.response != null) {
          try {
            newState=ProductDetailLoadingFailed(error.response!.data);
          } catch (e) {
            newState=ProductDetailLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState=ProductDetailLoadingFailed("Please check your internet connection!");
          } else {
            newState=ProductDetailLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    }
  }

}