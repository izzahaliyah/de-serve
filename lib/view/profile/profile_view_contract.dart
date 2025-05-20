import '../../model/user_model.dart';

abstract class ProfileViewContract {
  void showProfile(UserModel profile);
  void onUpdateSuccess();
  void onError(String message);
}
