abstract class QuestionsEvent{}

class LoadQuestions extends QuestionsEvent{
  String id;
  String query;

  LoadQuestions(this.id, this.query);
}

class LoadMoreQuestions extends QuestionsEvent{
}

class PostQuestion extends QuestionsEvent {
  String id;
  String question;

  PostQuestion(this.id, this.question);
}