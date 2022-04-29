import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class UserDao {

  static final UserDao _singleton = UserDao._internal();

  factory UserDao() {
    return _singleton;
  }

  UserDao._internal();

  void saveUser(UserVO? userVO) async {
    if(userVO != null) {
      await getUserBox().put(userVO.id, userVO);
      print("Saved user.......");
    }
  }

  UserVO? getUserById(int userId) {
    return getUserBox().get(userId);
  }

  void deleteUser(UserVO? userVO) async {
    await getUserBox().delete(userVO?.id);
    print("Delete successfully");

  }

  UserVO? findUserIsExist() {
    if(getUserList().isNotEmpty) {
      print("User list length in dao : ${getUserList().length}");
      return getUserList().first;
    } else {
      return null;
    }
  }

  List<UserVO> getUserList() {
    return getUserBox().values.toList();
  }

  /// Reactive Programming
  Stream<void> getUserEventStream() {
    print("Get user event stream work......");
    return getUserBox().watch();
  }

  Stream<UserVO?> getUserStream(int userId) {
    // return Stream.value(getUserById(userId));
    print("getUserStream(int userId): ${getUserById(getUserList().first.id ?? 0)}");
    return Stream.value(getUserById(getUserList().first.id ?? 0));
  }

  UserVO? getUser(int userId) {
    print("getUser(int userId) ${getUserById(getUserList().first.id ?? 0)}....");
    if(getUserById(getUserList().first.id ?? 0) != null) {
      // return getUserById(userId);
      return getUserById(getUserList().first.id ?? 0);
    } else {
      UserVO userVo = UserVO(0, "", "", "", 0, "", []);
      userVo.token = "";
      return userVo;
    }
  }

  Box<UserVO> getUserBox() {
    return Hive.box<UserVO>(BOX_NAME_USER_VO);
  }
}