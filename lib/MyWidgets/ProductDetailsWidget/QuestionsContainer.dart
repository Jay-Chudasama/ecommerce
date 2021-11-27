import 'package:ecommerce/models/product_details_model.dart';
import 'package:ecommerce/productdetails/product_details_state.dart';
import 'package:ecommerce/questions/questions_bloc.dart';
import 'package:ecommerce/questions/questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../RoundedContainer.dart';
import '../ShimmerContainer.dart';

class QuestionsContainer extends StatelessWidget {
  late ProductDetailLoaded state;

  bool shimmer = false;


  QuestionsContainer.shimmer({this.shimmer=true});

  QuestionsContainer(this.state);

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
              Padding(
                padding: const EdgeInsets.only(left: 8,bottom: 8.0),
                child:    Container(
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        )),
                    elevation: MaterialStateProperty.all(0),
                    fixedSize:
                    MaterialStateProperty.all(Size(double.maxFinite, 50))),
                child: Text(
                  'Ask',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))
          ]),
        ));
  }

  _originalView(context){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          if(state.data.questions!.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:   Text("No Questions"),
            ),
          ...state.data.questions!.map((e) => _questionItem(e)).toList(),
          if(state.data.questions!.isNotEmpty)
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(create: (_)=>QuestionsBloc(),child: QuestionsScreen(state.data.id!),)));
                },
                child: Text(
                  'Show All',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider(create: (_)=>QuestionsBloc(),child: QuestionsScreen(state.data.id!,askMode: true,),)));
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                  elevation: MaterialStateProperty.all(0),
                  fixedSize:
                  MaterialStateProperty.all(Size(double.maxFinite, 50))),
              child: Text(
                'Ask',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ))
        ]));
  }

  _questionItem(Questions question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q. ${question.question}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            question.answer.toString(),
          ),
        ),
      ],
    );
  }
}
