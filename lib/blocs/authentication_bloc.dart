import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

class AuthenticationBloc extends ChangeNotifier {
  /// States
  UserVO? userVo;

  /// Model
  UserModel userModel = UserModelImpl();

  AuthenticationBloc() {}

  Future<UserVO?> onTapLogin(String email, String password) {
    return userModel
        .postUserLogin(email, password)
        .then((userVo) => Future.value(userVo))
        .catchError((error) {
      debugPrint(error.toString());
    });
  }

  Future<UserVO?> onTapSignUp(
    String name,
    String email,
    String phone,
    String password,
    String? gToken,
    String? fbToken,
  ) {
    return userModel
        .postUserRegistration(name, email, phone, password, gToken, fbToken)
        .then((userVo) => Future.value(userVo))
        .catchError((error) {
      debugPrint(error.toString());
    });
  }

  Future<UserVO?> onTapLoginWithFacebook(String fbToken) {
    return userModel
        .postUserLoginFacebook(fbToken)
        .then((user) => Future.value(user))
        .catchError((error) {
      debugPrint(error.toString());
    });
  }

  Future<UserVO?> onTapLoginWithGoogle(String gToken) {
    return userModel
        .postUserLoginGoogle(gToken)
        .then((user) => Future.value(user))
        .catchError((error) {
      debugPrint(error.toString());
    });
  }
}
