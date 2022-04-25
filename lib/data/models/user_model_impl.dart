import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/vos/logout_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_booking_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_booking_app/persistence/daos/user_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class UserModelImpl extends UserModel {
  static final UserModelImpl _singleton = UserModelImpl._internal();

  factory UserModelImpl() {
    return _singleton;
  }

  UserModelImpl._internal();

  MovieDataAgent _dataAgent = RetrofitDataAgentImpl();

  /// Get Bearer Token String
  String getBearerToken(String token) {
    return "Bearer $token";
  }

  /// Daos
  UserDao userDao = UserDao();

  @override
  Future<UserVO?> postUserRegistration(
      String? name,
      String? email,
      String? phone,
      String? password,
      String? googleToken,
      String? facebookToken) {
    return _dataAgent
        .postUserRegistration(name ?? "", email ?? "", phone ?? "",
            password ?? "", googleToken, facebookToken)
        .then((userVo) async {
      userDao.saveUser(userVo);
      return Future.value(userVo);
    });
  }

  @override
  Future<UserVO?> postUserLogin(String? email, String? password) {
    return _dataAgent
        .postUserLogin(email ?? "", password ?? "")
        .then((userVo) async {
      print("Model Impl ${userVo.toString()}");
      userDao.saveUser(userVo);
      return Future.value(userVo);
    });
  }

  @override
  Future<UserVO?> postUserLoginGoogle(String? gToken) {
    // print("Google Login Token is $gToken");
    return _dataAgent.postUserLoginGoogle(gToken ?? "").then((userVo) async {
      print("Google Login Model Impl ${userVo.toString()}");
      userDao.saveUser(userVo);
      return Future.value(userVo);
    });
  }

  @override
  Future<UserVO?> postUserLoginFacebook(String? fbToken) {
    print("Facebook Login Token is $fbToken}");
    return _dataAgent.postUserLoginFacebook(fbToken ?? "").then((userVo) async {
      print("Facebook Login Model Imple ${userVo.toString()}");
      userDao.saveUser(userVo);
      return Future.value(userVo);
    });
  }

  @override
  Future<LogoutVO?> postLogout(String? token) {
    return _dataAgent.postLogout(getBearerToken(token ?? ""));
  }

  /// Database
  @override
  Stream<UserVO?> getUserByIdFromDatabase(int userId) {
    // return Future.value(userDao.getUserById(userId));
    return userDao
        .getUserEventStream()
        .startWith(userDao.getUserStream(userId))
        .map((event) {
      print("User DAO with map function ID is $userId");
      return userDao.getUser(userId);
    });
  }

  @override
  void deleteUserFromDatabase(UserVO userVo) {
    userDao.deleteUser(userVo);
  }

  @override
  UserVO? findUserExistsInDatabase() {
    return userDao.findUserIsExist();
  }
}
