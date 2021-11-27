import 'package:dio/dio.dart';
import 'package:ecommerce/models/question_model.dart';
import 'package:ecommerce/questions/questions_event.dart';
import 'package:ecommerce/questions/questions_repository.dart';
import 'package:ecommerce/questions/questions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionsBloc extends Bloc<QuestionsEvent,QuestionsState>{
  QuestionsBloc() : super(QuestionsInitial());
  QuestionsRepository _questionsRepository = QuestionsRepository();

  @override
  Stream<QuestionsState> mapEventToState(QuestionsEvent event) async*{
    QuestionsState newState;

    if (event is LoadQuestions) {
      newState = QuestionsLoading();
      yield newState;
      await _questionsRepository.loadQuestions(event.id,event.query).then((response) {
        var data = response.data;
        List<QuestionModel> list = List.from(
            data['results'].map((json) => QuestionModel.fromJson(json)));
        newState = QuestionsLoaded(
            data['count'], data['next'], data['previous'], list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = QuestionsLoadingFailed(error.response!.data);
          } catch (e) {
            newState = QuestionsLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                QuestionsLoadingFailed("Please check your internet connection!");
          } else {
            newState = QuestionsLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    } else if (event is LoadMoreQuestions) {
      newState = state;
      QuestionsLoaded oldstate = state as QuestionsLoaded;
      ///same home.fragments.notification
      await _questionsRepository
          .loadMoreQuestions(nextUrl: oldstate.next!)
          .then((response) {
        var data = response.data;
        List<QuestionModel> list = List.from(
            data['results'].map((json) => QuestionModel.fromJson(json)));
        oldstate.questions.addAll(list);
        newState = QuestionsLoaded(data['count'], data['next'],
            data['previous'] ,oldstate.questions);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = MoreQuestionsLoadingFailed(error.response!.data,oldstate);
          } catch (e) {
            newState = MoreQuestionsLoadingFailed(error.response!.data['detail'],oldstate);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                MoreQuestionsLoadingFailed("Please check your internet connection!",oldstate);
          } else {
            newState = MoreQuestionsLoadingFailed(error.message,oldstate);
          }
        }
      });
      yield newState;
    } else if (event is PostQuestion) {
      newState = PostingQuestion();
      yield newState;
      await _questionsRepository.postQuestion(event.id,event.question).then((response) {
        List<QuestionModel> list = [QuestionModel.fromJson(response.data)];
        newState = QuestionsLoaded(
            0,null,null, list);
      }).catchError((value) {
        DioError error = value;
        if (error.response != null) {
          try {
            newState = QuestionsLoadingFailed(error.response!.data);
          } catch (e) {
            newState = QuestionsLoadingFailed(error.response!.data['detail']);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState =
                QuestionsLoadingFailed("Please check your internet connection!");
          } else {
            newState = QuestionsLoadingFailed(error.message);
          }
        }
      });
      yield newState;
    }

  }


}