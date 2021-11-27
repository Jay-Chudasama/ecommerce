import 'package:ecommerce/MyWidgets/OrderDetialsWidget/MyReviewContainer.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/models/order_details_model.dart';
import 'package:ecommerce/orderdetails/orderdetails_state.dart';
import 'package:ecommerce/productdetails/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils.dart';
import '../RoundedContainer.dart';

class RatingsContainer extends StatelessWidget {
  late ProductDetailLoaded state;

  bool shimmer = false;


  RatingsContainer.shimmer({this.shimmer=true});

  RatingsContainer(this.state);

  @override
  Widget build(BuildContext context) {
  return shimmer?_shimmerView():_originalView();
  }

  _ratingProgress(title, color, count, progress) {
    return Row(
      children: [
        Text(
          title + ' ',
          style: TextStyle(fontSize: 12,height: 1.8),
        ),
        Icon(
          FontAwesomeIcons.solidStar,
          size: 12,
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(count.toString(), style: TextStyle(fontSize: 12)),
      ],
    );
  }

  _shimmerRatingProgress(){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            color: Colors.white,
          ),
          Icon(
            FontAwesomeIcons.solidStar,
            size: 12,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: 1,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            height: 10,
            width: 10,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  _shimmerView(){

    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: ShimmerContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: 100,
                color: Colors.white,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 60,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          FontAwesomeIcons.solidStar,
                          size: 32,
                          color: Colors.amber,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                     _shimmerRatingProgress(),
                     _shimmerRatingProgress(),
                     _shimmerRatingProgress(),
                     _shimmerRatingProgress(),
                     _shimmerRatingProgress(),
                        Divider(),
                        Container(
                          height: 15,
                          width: 100,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),

            ],
          ),
        ));
  }

  _originalView(){
    late String rating = average(state.data);

    var total = state.data.star1! +
        state.data.star2! +
        state.data.star3! +
        state.data.star4! +
        state.data.star5!;



    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ratings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        rating,
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold,height: 1.7),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        FontAwesomeIcons.solidStar,
                        size: 32,
                        color: Colors.amber,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _ratingProgress("5", Colors.green, state.data.star5,
                          total>0?state.data.star5! / total:0.0),
                      _ratingProgress("4", Colors.greenAccent, state.data.star4,
                          total>0?state.data.star4! / total:0.0),
                      _ratingProgress("3", Colors.lightGreenAccent,
                          state.data.star3, total>0?state.data.star3! / total:0.0),
                      _ratingProgress("2", Colors.yellow, state.data.star2,
                          total>0?state.data.star2! / total:0.0),
                      _ratingProgress("1", Colors.red, state.data.star1,
                          total>0?state.data.star1! / total:0.0),
                      Divider(),
                      Text('Total Ratings : $total')
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            if (state.data.myReview != null)
             Center(child: MyReviewContainer(OrderDetailsLoaded(OrderDetailsModel(myReview: state.data.myReview)),onlyRatingBar: true,))
          ],
        ));
  }


}
