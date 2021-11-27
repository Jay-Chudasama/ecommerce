import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/models/product_details_model.dart';
import 'package:ecommerce/productdetails/product_details_state.dart';
import 'package:ecommerce/reviews/reviews_bloc.dart';
import 'package:ecommerce/reviews/reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../RoundedContainer.dart';

class ReviewsContainer extends StatelessWidget {
  late ProductDetailLoaded state;
  bool shimmer = false;


  ReviewsContainer.shimmer({this.shimmer=true});

  ReviewsContainer(this.state);

  @override
  Widget build(BuildContext context) {
   return shimmer?_shimmerView():_originalView(context);
  }

  _shimmerView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: ShimmerContainer(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
            height: 25,
            width: 100,
            color: Colors.white,
          ),
            SizedBox(
              height: 16,
            ),
        _shimmerItem(),
        _shimmerItem(),
        _shimmerItem(),
            TextButton(
                onPressed: null,
                child: Text(
                  'Show All',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ))
          ]),
        ));
  }

  _originalView(context){
    return  RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          ...state.data.reviews!.map((e) => _reviewItem(e)).toList(),
          TextButton(
              onPressed: () {
Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(create: (_)=>ReviewsBloc(),child: ReviewsScreen(state.data.id!),)));
              },
              child: Text(
                'Show All',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
        ]));
  }

  _shimmerItem(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
     
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 4,
          ),
          Icon(
            FontAwesomeIcons.solidStar,
            size: 12,
            color: Colors.amber,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              height: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  _reviewItem(Reviews review) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
      child: Row(
        children: [
          Text(
            review.rating.toString(),
            style: TextStyle(fontWeight: FontWeight.bold,height: 1.8),
          ),
          SizedBox(
            width: 4,
          ),
          Icon(
            FontAwesomeIcons.solidStar,
            size: 12,
            color: Colors.amber,
          ),
          SizedBox(
            width: 16,
          ),
          Text(review.review!),
        ],
      ),
    );
  }
}
