import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class SnackDao {
  static final SnackDao _singleton = SnackDao._internal();

  factory SnackDao() {
    return _singleton;
  }

  SnackDao._internal();

  void saveSnacks(List<SnackVO>? snacks) async {
    Map<int, SnackVO> snackMap = Map.fromIterable(snacks ?? [],
        key: (snack) => snack.id, value: (snack) => snack);
    await getSnackBox().putAll(snackMap);
  }

  List<SnackVO> getAllSnackList() {
    return getSnackBox().values.toList();
  }

  Box<SnackVO> getSnackBox() {
    return Hive.box<SnackVO>(BOX_NAME_SNACK_VO);
  }

  /// Reactive Programming
  Stream<void> getAllSnacksEventStream() {
    return getSnackBox().watch();
  }

  Stream<List<SnackVO>> getSnacksStream() {
    return Stream.value(getAllSnackList());
  }

  List<SnackVO> getSnacks() {
    if(getAllSnackList() != null && getAllSnackList().isNotEmpty) {
      return getAllSnackList();
    } else {
      return [];
    }
  }
}
