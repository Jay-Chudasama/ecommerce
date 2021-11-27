import 'package:ecommerce/models/question_model.dart';

abstract class QuestionsState{}

class QuestionsInitial extends QuestionsState {}
class QuestionsLoading extends QuestionsState{}
class QuestionsLoaded extends QuestionsState{
  int count;
  String? next;
  String? previous;
  List<QuestionModel> questions;

  QuestionsLoaded(this.count, this.next, this.previous, this.questions);
}
class QuestionsLoadingFailed extends QuestionsState{
  String message;

  QuestionsLoadingFailed(this.message);
}

class MoreQuestionsLoadingFailed extends QuestionsState{
  String message;
  QuestionsLoaded loadedQuestions;

  MoreQuestionsLoadingFailed(this.message, this.loadedQuestions);
}

class PostingQuestion extends QuestionsState{}
