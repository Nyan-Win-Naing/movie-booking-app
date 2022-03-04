import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/cinema_list_for_hive_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class CinemaDao {
  static final CinemaDao _singleton = CinemaDao._internal();

  factory CinemaDao() {
    return _singleton;
  }

  CinemaDao._internal();

  List<CinemaVO> cinemaList = [];


  Box<CinemaListForHiveVO> getCinemaBox() {
    return Hive.box<CinemaListForHiveVO>(BOX_NAME_CINEMA_VO_FOR_HIVE);
  }

  // void saveCinemas(String movieDate, List<CinemaVO>? cinemas) async {
  //   await getCinemaBox().put(movieDate, cinemas ?? []);
  //   print("Save Cinemas Successfully $movieDate ====> $cinemas}");
  // }

  void saveCinemas(String movieDate, CinemaListForHiveVO cinemaListForHiveVo) async {
    await getCinemaBox().put(movieDate, cinemaListForHiveVo);
  }

  CinemaListForHiveVO? getCinema(String movieDate) {
    return getCinemaBox().get(movieDate);
  }

  /// Reactive Programming
  Stream<void> getCinemasEventStream() {
    return getCinemaBox().watch();
  }

  Stream<CinemaListForHiveVO?> getCinemasStream(String movieDate) {
    return Stream.value(getCinema(movieDate));
  }

  CinemaListForHiveVO? getCinemaByDate(String movieDate) {
    if(getCinema(movieDate) != null) {
      return getCinema(movieDate);
    } else {
      return CinemaListForHiveVO([]);
    }
  }

  // List<CinemaVO> getCinema(String movieDate) {
  //   print("Get Cinema From Database: $movieDate");
  //   print("Get Cinemas retrieve by date: ${getCinemaBox().get(movieDate)}");
  //   return getCinemaBox().get(movieDate, defaultValue: cinemaList) as List<CinemaVO>;
  // }
}