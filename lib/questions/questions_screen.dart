import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/OrderItem.dart';
import 'package:ecommerce/MyWidgets/QuestionItem.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/models/question_model.dart';
import 'package:ecommerce/questions/questions_bloc.dart';
import 'package:ecommerce/questions/questions_event.dart';
import 'package:ecommerce/questions/questions_state.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class QuestionsScreen extends StatelessWidget {

  late String id;
String question = "";
late bool askMode;

  QuestionsScreen(this.id,{this.askMode=false});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: _searchField(true,context),titleSpacing: 0,),
      body: BlocConsumer<QuestionsBloc, QuestionsState>(
          builder: (context, state) {
            if (state is QuestionsInitial) {
              BlocProvider.of<QuestionsBloc>(context).add(LoadQuestions(id,""));
            }

            if (state is QuestionsLoadingFailed) {
              return FailureMessage(
                message: state.message,
                onRetry: () {
                  BlocProvider.of<QuestionsBloc>(context)
                      .add(LoadQuestions(id,""));
                },
              );
            }
            if (state is QuestionsLoaded ||
                state is MoreQuestionsLoadingFailed) {
              QuestionsLoaded _loadedQuestions =
              state is MoreQuestionsLoadingFailed
                  ? state.loadedQuestions
                  : state as QuestionsLoaded;
              if(_loadedQuestions.questions.length == 0){
                return  SingleChildScrollView(
                  child: RoundedContainer(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        QuestionItem(QuestionModel(question: question,answer: "")),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                )),
                                elevation: MaterialStateProperty.all(0),
                                fixedSize: MaterialStateProperty.all(
                                    Size(double.maxFinite, 50))),
                            onPressed: (state is PostingQuestion)
                                ? null
                                : () {
                              if(question.isNotEmpty) {
                                BlocProvider.of<QuestionsBloc>(context)
                                    .add(PostQuestion(id, question));
                              }
                            },

                            child: (state is PostingQuestion)
                                ? SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                              width: 25,
                              height: 25,
                            )
                                : Text(
                              'Post',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                );
              }else {
                return _loadedQuestions.questions.length> 0?ListView.builder(
                  itemBuilder: (context, index) {
                    if (index < _loadedQuestions.questions.length) {
                      return QuestionItem(_loadedQuestions.questions[index]);
                    } else {
                      if (state is MoreQuestionsLoadingFailed) {
                        return FailureMessage(
                            message: state.message, onRetry: null);
                      }
                      BlocProvider.of<QuestionsBloc>(context)
                          .add(LoadMoreQuestions());
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  itemCount: _loadedQuestions.next != null
                      ? _loadedQuestions.questions.length + 1
                      : _loadedQuestions.questions.length,
                ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
              }
            }

            return ListView.builder(itemBuilder: (context,index){
              return QuestionItem.shimmer();
            },);
          }, listener: (context, state) {
        if (state is QuestionsLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
        if (state is MoreQuestionsLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
      }),
    );
  }

  Widget _searchField(enabled,context) {
    return Container(
      color: PRIMARY_SWATCH,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: TextFormField(
        enabled: enabled,
        autofocus: askMode,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value){
          question  = value;
          BlocProvider.of<QuestionsBloc>(context)
              .add(LoadQuestions(id,value));
        },
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          hintText: askMode?"Ask your question...":'Search',
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: FOCUSED_BORDER,
          focusedBorder: FOCUSED_BORDER,
          disabledBorder: FOCUSED_BORDER,
          prefixIconConstraints: BoxConstraints.tight(Size(40, 30)),
          prefixIcon: Center(
              child: Icon(
                Icons.search,
                color: Colors.grey,
              )),
        ),
      ),
    );
  }
  
}
