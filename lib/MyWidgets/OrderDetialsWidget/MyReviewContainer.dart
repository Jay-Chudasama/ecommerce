import 'package:ecommerce/orderdetails/MyReviewCubit/MyReviewCubit.dart';
import 'package:ecommerce/orderdetails/MyReviewCubit/MyReviewState.dart';
import 'package:ecommerce/orderdetails/orderdetails_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../RoundedContainer.dart';

class MyReviewContainer extends StatelessWidget {
  late OrderDetailsLoaded orderState;
  late bool onlyRatingBar;
  String review = "";

  int rating = 0;

  MyReviewContainer(this.orderState, {this.onlyRatingBar = false}) {
    if (orderState.details.myReview != null) {
      review = orderState.details.myReview!.review!;
      rating = orderState.details.myReview!.rating!;
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyReviewCubit>(
      create: (_) => MyReviewCubit(),
      child: BlocConsumer<MyReviewCubit, MyReviewState>(
        listener: (context, state) {
          if (state is MyReviewFailed) {
            if (state.message == UNAUTHENTICATED_USER) {
              BlocProvider.of<AuthCubit>(context).removeToken();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ///force logout
            }

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }

          if (state is MyReviewUpdated) {
            orderState.details.myReview = state.my_review;
          }
        },
        builder: (context, state) => RoundedContainer(
          margin: EdgeInsets.all(onlyRatingBar?0:8),
          child: Column(
            children: [
              if (!onlyRatingBar)
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Your Rating",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: onlyRatingBar?0:16.0),
                child: RatingBar.builder(
                  wrapAlignment: WrapAlignment.spaceAround,
                  initialRating: orderState.details.myReview != null
                      ? orderState.details.myReview!.rating!.toDouble()
                      : 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  itemBuilder: (context, _) => Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    this.rating = rating.toInt();
                    context.read<MyReviewCubit>().updateReview(
                        orderState.details.myReview?.id,
                        orderState.details.id,
                        this.rating,
                        review);
                  },
                ),
              ),
              if (!onlyRatingBar) ...[
                Form(
                    key: formKey,
                    child: _reviewField(
                        orderState.details.myReview?.review!, true)),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        )),
                        elevation: MaterialStateProperty.all(0),
                        fixedSize: MaterialStateProperty.all(
                            Size(double.maxFinite, 45))),
                    onPressed: state is MyReviewUpdating
                        ? null
                        : () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            if (formKey.currentState!.validate())
                              context.read<MyReviewCubit>().updateReview(
                                  orderState.details.myReview?.id,
                                  orderState.details.id,
                                  rating,
                                  review);
                          },
                    child: state is MyReviewUpdating
                        ? CircularProgressIndicator()
                        : Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewField(initValue, enabled) {
    return TextFormField(
      enabled: enabled,
      maxLines: 3,
      style: TextStyle(fontSize: 14),
      initialValue: initValue,
      validator: (value) {
        if (value != null) review = value;
      },
      decoration: InputDecoration(
        enabledBorder: ENABLED_BORDER,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_BORDER,
        errorStyle: TextStyle(height: 1),
        hintText: "Write your review for this product...",
        fillColor: Colors.white,
        filled: true,
        labelText: 'Your Review',
      ),
    );
  }
}
