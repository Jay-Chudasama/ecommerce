import 'package:ecommerce/models/product_details_model.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  ProductDetailsModel data;

  ProductDetailLoaded(this.data);
}

class ProductDetailLoadingFailed extends ProductDetailState {
  String message;

  ProductDetailLoadingFailed(this.message);
}
