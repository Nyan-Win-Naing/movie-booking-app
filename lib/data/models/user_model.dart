import 'package:movie_booking_app/data/vos/logout_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

abstract class UserModel {
  // Network
  Future<UserVO?> postUserRegistration(String? name, String? email, String? phone, String? password, String? googleToken, String? facebookToken);
  Future<UserVO?> postUserLogin(String? email, String? password);
  Future<UserVO?> postUserLoginGoogle(String? gToken);
  Future<UserVO?> postUserLoginFacebook(String? fbToken);
  Future<LogoutVO?> postLogout(String? token);

  // Database
  Stream<UserVO?> getUserByIdFromDatabase(int userId);
  void deleteUserFromDatabase(UserVO userVo);
  UserVO? findUserExistsInDatabase();
}