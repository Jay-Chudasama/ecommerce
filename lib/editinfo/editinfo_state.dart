abstract class EditInfoState{}

class EditInfoInitial extends EditInfoState{}
class EditInfoSubmitting extends EditInfoState{}
class EditInfoOtpRequested extends EditInfoState{}
class EditInfoSubmitted extends EditInfoState{}
class EditInfoFailed extends EditInfoState{
  String message;

  EditInfoFailed(this.message);
}