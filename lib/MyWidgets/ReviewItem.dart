import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'RoundedContainer.dart';

class ReviewItem extends StatelessWidget {
 late  ReviewModel _reviewModel;
 bool shimmer = false;

  ReviewItem(this._reviewModel);

  ReviewItem.shimmer({this.shimmer=true});

 @override
  Widget build(BuildContext context) {
    return shimmer?_shimmerView():_originalView();
  }
  
  _originalView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              _reviewModel.rating.toString(),
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
            Text(_reviewModel.review!),
          ],
        )
    );
  }
  
  _shimmerView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        child: ShimmerContainer(
          child: Row(
            children: [
              Container(color: Colors.white,height: 10,width: 10,),
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
              Container(color: Colors.white,height: 16,width: 100,),
            ],
          ),
        )
    );
  }
}
