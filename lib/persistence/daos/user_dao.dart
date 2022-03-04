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
    return getUserBox().watch();
  }

  Stream<UserVO?> getUserStream(int userId) {
    print("Get User Stream in DAO....");
    return Stream.value(getUserById(userId));
  }

  UserVO? getUser(int userId) {
    if(getUserById(userId) != null) {
      return getUserById(userId);
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