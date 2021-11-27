import 'package:ecommerce/MyWidgets/CartIconButton.dart';
import 'package:ecommerce/MyWidgets/CouponItem.dart';
import 'package:ecommerce/MyWidgets/ProductDetailsWidget/ProductLikeButton.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/cart/cart_event.dart';
import 'package:ecommerce/home/fragments/cart/cart_screen.dart';
import 'package:ecommerce/home/fragments/cart/cart_state.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_event.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_state.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/productdetails/StockOutCubit/StockCubit.dart';
import 'package:ecommerce/productdetails/StockOutCubit/StockState.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';
import '../MyWidgets/ProductDetailsWidget/DescriptionContainer.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/ProductImagesCarousel.dart';
import '../MyWidgets/ProductDetailsWidget/ProductOptionsContainer.dart';
import '../MyWidgets/ProductDetailsWidget/QuestionsContainer.dart';
import '../MyWidgets/ProductDetailsWidget/RatingsContainer.dart';
import '../MyWidgets/ProductDetailsWidget/ReviewsContainer.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import '../MyWidgets/ProductDetailsWidget/SpecificationContainer.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product_details_model.dart';
import 'package:ecommerce/productdetails/product_details_bloc.dart';
import 'package:ecommerce/productdetails/product_details_event.dart';
import 'package:ecommerce/productdetails/product_details_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils.dart';

class ProductDetailsScreen extends StatelessWidget {
  late String id;
  late AccountBloc _accountBloc;

  ProductDetailsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    return Scaffold(
      body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ProductDetailInitial) {
              context.read<ProductDetailBloc>().add(LoadProduct(id));
            }

            if (state is ProductDetailLoadingFailed) {
              return FailureMessage(
                message: state.message,
                onRetry: () {
                  context.read<ProductDetailBloc>().add(LoadProduct(id));
                },
              );
            }

            if (state is ProductDetailLoaded) {
              ProductOptionsContainer optionsContainer =
                  ProductOptionsContainer(state.data);
              return BlocProvider<StockCubit>(
                create: (BuildContext context) => StockCubit(),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 80),
                                optionsContainer,
                                SizedBox(
                                  height: 8,
                                ),
                                if (state.data.coupon != null)
                                  CouponItem(state.data.coupon!),
                                SizedBox(
                                  height: 8,
                                ),
                                DescriptionContainer(state.data.description!),
                                if (state.data.specifications!.isNotEmpty)
                                  SpecificationContainer(state),
                                RatingsContainer(state,),
                                if (state.data.reviews!.isNotEmpty)
                                  ReviewsContainer(state),
                                QuestionsContainer(state)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: AppBar(
                              shadowColor: Colors.transparent,
                              iconTheme: IconThemeData(color: Colors.black),
                              backgroundColor: Colors.transparent,
                              actions: [
                                SizedBox(
                                  height: 24,
                                  child: BlocBuilder<StockCubit, StockState>(
                                    builder: (context, state) =>ProductLikeButton(optionsContainer.selectedOptionId),
                                  ),
                                ),
                                CartIconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                                  value:
                                                      BlocProvider.of<CartBloc>(
                                                          context),
                                                  child: CartScreen(),
                                                )));
                                  },
                                  color: PRIMARY_SWATCH,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: INPUT_BORDER_COLOR,
                              offset: Offset.zero,
                              blurRadius: 20,
                              spreadRadius: 0)
                        ],
                      ),
                      child: BlocBuilder<StockCubit, StockState>(
                          builder: (context, state) {
                        if (state is StockOut) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "OUT OF STOCK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ),
                          );
                        }
                        return Row(
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<AccountBloc, AccountState, int>(
                                selector: (state) {
                                  return state.userdata.cart!.length;
                                },
                                builder: (context, state) => TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(_accountBloc
                                                  .state.userdata.cart!
                                                  .contains(optionsContainer
                                                      .selectedOptionId)
                                              ? Colors.redAccent
                                              : PRIMARY_SWATCH),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder()),
                                      elevation: MaterialStateProperty.all(0),
                                      fixedSize: MaterialStateProperty.all(
                                          Size(double.maxFinite, 50))),
                                  onPressed: () {
                                    if (_accountBloc.state.userdata.cart!
                                        .contains(optionsContainer
                                            .selectedOptionId)) {
                                      _accountBloc.add(RemoveFromUserCart(
                                          optionsContainer.selectedOptionId));

                                      context.read<CartBloc>().add(
                                          RemoveFromCart(optionsContainer
                                              .selectedOptionId));
                                    } else {
                                      _accountBloc.add(AddToUserCart(
                                          optionsContainer.selectedOptionId));
                                      context.read<CartBloc>().add(AddToCart(
                                          optionsContainer.selectedOptionId));
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _accountBloc.state.userdata.cart!
                                                .contains(optionsContainer
                                                    .selectedOptionId)
                                            ? "REMOVE"
                                            : "ADD TO CART",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.shoppingCart,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder()),
                                    elevation: MaterialStateProperty.all(0),
                                    fixedSize: MaterialStateProperty.all(
                                        Size(double.maxFinite, 50))),
                                onPressed: () {
                                  ProductDetailLoaded details = context
                                      .read<ProductDetailBloc>()
                                      .state as ProductDetailLoaded;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                            create: (_) => CartBloc(CartLoaded([
                                              CartModel(
                                                  id: optionsContainer
                                                      .selectedOptionId,
                                                  image: optionsContainer.image,
                                                  option: optionsContainer
                                                      .selectedOption,
                                                  quantity: (state as InStock)
                                                      .quantity,
                                                  productDetails: ProductDetails(
                                                      id: id,
                                                      title: details.data.title,
                                                      price: details.data.price,
                                                      offerPrice: details
                                                          .data.offerPrice,
                                                      deliveryCharge: details
                                                          .data.deliveryCharge,
                                                      cod: details.data.cod,
                                                      maxQuantity: details
                                                          .data.maxQuantity,
                                                      coupon:
                                                          details.data.coupon !=
                                                                  null
                                                              ? "free_coupon"
                                                              : null))
                                            ]),fromCart: false),
                                            child: CartScreen(),
                                          )));
                                },
                                child: Text(
                                  "BUY NOW",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    )
                  ],
                ),
              );
            }
//          shimmer
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80),
                            ProductOptionsContainer.shimmer(),
                            SizedBox(
                              height: 8,
                            ),
                            CouponItem.shimmer(),
                            SizedBox(
                              height: 8,
                            ),
                            DescriptionContainer.shimmer(),
                            SpecificationContainer.shimmer(),
                            RatingsContainer.shimmer(),
                            ReviewsContainer.shimmer(),
                            QuestionsContainer.shimmer()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: null,
                                icon: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                )),
                            Spacer(),
                            SizedBox(
                              height: 24,
                              child: LikeButton(
                                bubblesColor: BubblesColor(
                                  dotSecondaryColor: Colors.redAccent,
                                  dotPrimaryColor: PRIMARY_SWATCH,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return isLiked
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 28,
                                        )
                                      : Icon(
                                          Icons.favorite_border_outlined,
                                          size: 28,
                                        );
                                },
                                isLiked: _accountBloc.state.userdata.wishlist!
                                    .contains(id),
                              ),
                            ),
                            IconButton(
                                onPressed: null,
                                icon: Icon(
                                  FontAwesomeIcons.shoppingCart,
                                  color: PRIMARY_SWATCH,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: INPUT_BORDER_COLOR,
                          offset: Offset.zero,
                          blurRadius: 20,
                          spreadRadius: 0)
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder()),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed: null,
                          child: Text(
                            "BUY NOW",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder()),
                              elevation: MaterialStateProperty.all(0),
                              fixedSize: MaterialStateProperty.all(
                                  Size(double.maxFinite, 50))),
                          onPressed: null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ADD TO CART",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                FontAwesomeIcons.shoppingCart,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
