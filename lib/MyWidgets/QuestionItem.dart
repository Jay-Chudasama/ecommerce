import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionItem extends StatelessWidget {
  late bool shimmer=false;
  late QuestionModel _model;


  QuestionItem.shimmer({this.shimmer=true});

  QuestionItem(this._model);

  @override
  Widget build(BuildContext context) {
    return shimmer?_shimmerView():_originalView();
  }

  _originalView(){
    return  RoundedContainer(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q. ${_model.question}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              _model.answer.toString(),
            ),
          ),
        ],
      ),
    );
  }


  _shimmerView(){
    return  RoundedContainer(
      margin: EdgeInsets.all(8),
      child: ShimmerContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.white,height: 15,margin: EdgeInsets.symmetric(vertical: 8),),
            Container(color: Colors.white,height: 15,margin: EdgeInsets.only(left: 24),),
          ],
        ),
      ),
    );
  }
}
