import 'package:dio/dio.dart';
import 'package:ecommerce/home/fragments/cart/cart_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_repository.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  late bool fromCart;
  CartBloc(CartState cartState,{this.fromCart=true}) : super(cartState);

  CartRepository _cartRepository = CartRepository();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    CartState newState;

    if (event is LoadCart) {
      newState = CartLoading();
      yield newState;
      await _cartRepository.loadCart().then((response) {
        var data = response.data;
        List<CartModel> list =
        List.from(data.map((json) => CartModel.fromJson(json)));
        newState = CartLoaded(list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = CartLoadingFailed(error.response!.data);
          } catch (e) {
            newState = CartLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                CartLoadingFailed("Please check your internet connection!");
          } else {
            newState = CartLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is AddToCart) {
     newState = state;
      await _cartRepository.add(event.id).then((response) {
        if (state is CartLoaded) {
          List<CartModel> list = (state as CartLoaded).cart;
          list.add(CartModel.fromJson(response.data));
          newState = CartLoaded(list);
        }
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = CartLoadingFailed(error.response!.data);
          } catch (e) {
            newState = CartLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                CartLoadingFailed("Please check your internet connection!");
          } else {
            newState = CartLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is RemoveFromCart) {
      if (state is CartLoaded) {
        List<CartModel> list = (state as CartLoaded).cart;
        list.removeWhere((element) => element.id == event.id);
        newState = CartLoaded(list);
      } else {
        newState = state;
      }
      yield newState;
      await _cartRepository.remove(event.id).then((response) {
//       do nothing
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = CartLoadingFailed(error.response!.data);
          } catch (e) {
            newState = CartLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                CartLoadingFailed("Please check your internet connection!");
          } else {
            newState = CartLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    }else if(event is UpdateQuantity){
      CartLoaded oldState = (state as CartLoaded);
      oldState.cart.singleWhere((element) => element.id==event.id).selectedQuantity = event.updatedQuantity;
      yield CartLoaded(oldState.cart);
    }else if(event is ApplyCoupon){
      CartLoaded oldstate = state as CartLoaded;
      newState = ValidatingCoupon(oldstate.cart);
      yield newState;
      await _cartRepository.applyCoupon(event.code, event.totalAmt).then((response) {
        newState = CouponApplied(response.data['discount_amount'],event.code, oldstate.cart);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = InvalidCoupon(error.response!.data,oldstate.cart);
          } catch (e) {
            newState = InvalidCoupon(error.response!.data['detail'],oldstate.cart);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                InvalidCoupon("Please check your internet connection!",oldstate.cart);
          } else {
            newState = InvalidCoupon(error.message,oldstate.cart);
          }
        }
      });
      yield newState;
    }else if(event is RemoveCoupon){
      yield CartLoaded((state as CartLoaded).cart);
    }else if(event is InitiatePayment){
      String? coupon_code;
      CartLoaded oldstate = state as CartLoaded;
      if(state is CouponApplied){
        coupon_code = (state as CouponApplied).couponCode;
        newState = InitiatingPaymentWithCoupon(event.cartTotals.discountAmt,coupon_code,(state as CouponApplied).cart);
      }else{
        newState = InitiatingPayment((state as CartLoaded).cart);
      }
      yield newState;
      await _cartRepository.initiatePayment(event.cartTotals,coupon_code,event.paymentMode,event.addressId,fromCart).then((response) {
        if(state is CouponApplied){
          newState = PaymentInitiatedWithCoupon(response.data['token'], response.data['orderId'], response.data['appId'], response.data['orderCurrency'], response.data['tx_amount'], event.cartTotals.discountAmt, coupon_code!, oldstate.cart);
        }else{
          newState = PaymentInitiated(response.data['token'], response.data['orderId'], response.data['appId'], response.data['orderCurrency'], response.data['tx_amount'],oldstate.cart);
        }
      }).catchError((value) {
        print(value);
        DioError error = value;
        if (error.response != null) {
          String message;
          try {
            try {

              String id =error.response!.data['id'];
                        int quantity = error.response!.data['available_quantity'];

              CartModel model = oldstate.cart.firstWhere((element) => element.id == id);
              model.quantity = quantity;
              if(model.quantity==0){
                message = "1 Product is out of Stock!";
                model.selectedQuantity = 0;
              }else{
                message = "1 Product is not available in Required Quantity!";
                model.selectedQuantity = 1;
              }
            } catch (e) {
              message = error.response!.data;
            }

            newState = PaymentInitiationFailed(message,oldstate.cart);
          } catch (e) {
            newState = PaymentInitiationFailed(error.response!.data['detail'],oldstate.cart);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                PaymentInitiationFailed("Please check your internet connection!",oldstate.cart);
          } else {
            newState = PaymentInitiationFailed(error.message,oldstate.cart);
          }
        }
      });
      yield newState;
    }else if(event is RemoveOrderedProducts && fromCart){
      CartLoaded oldstate = state as CartLoaded;
      oldstate.cart.removeWhere((element) => event.cartTotals.cartItems.contains(element));
      yield CartLoaded(oldstate.cart);
    }
  }
}
