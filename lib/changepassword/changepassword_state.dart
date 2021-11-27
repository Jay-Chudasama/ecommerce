abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState{}
class ChangePasswordSubmitting extends ChangePasswordState{}
class ChangePasswordSubmitted extends ChangePasswordState{}
class ChangePasswordFailed extends ChangePasswordState{
  String message;

  ChangePasswordFailed(this.message);
}
