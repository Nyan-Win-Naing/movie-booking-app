import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'cinema_list_for_hive_vo.g.dart';

@HiveType(typeId: HIVE_TYPE_ID_CINEMA_LIST_FOR_HIVE, adapterName: "CinemaListForHiveVOAdapter")
class CinemaListForHiveVO {
  @HiveField(0)
  List<CinemaVO>? cinemaList;

  CinemaListForHiveVO(this.cinemaList);

  @override
  String toString() {
    return 'CinemaListForHiveVO{cinemaList: $cinemaList}';
  }
}