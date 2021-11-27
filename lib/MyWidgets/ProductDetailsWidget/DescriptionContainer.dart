import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../RoundedContainer.dart';

class DescriptionContainer extends StatelessWidget {
  late String description;
  bool shimmer = false;


  DescriptionContainer.shimmer({this.shimmer=true});

  DescriptionContainer(this.description);

  @override
  Widget build(BuildContext context) {
    if(shimmer){
      return _shimmerView();
    }
    else{
      return _originalView();
    }

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
              Container(
                height: 100,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }

  _originalView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(description),
          ],
        ));
  }
}
