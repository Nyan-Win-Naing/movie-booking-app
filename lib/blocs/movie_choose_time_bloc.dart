import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/dummy/movie_choose_date_list.dart';

class MovieChooseTimeBloc extends ChangeNotifier {
  /// States
  UserVO? userVo;
  List<CinemaVO>? cinemaList;
  CinemaVO? selectedCinema;

  List<MovieChooseDateVO>? movieDateList;
  MovieChooseDateVO? movieChooseDateVo;

  /// Models
  UserModel userModel = UserModelImpl();
  MovieModel movieModel = MovieModelImpl();

  bool _dispose = false;

  MovieChooseTimeBloc(UserVO? userVo, int movieId) {
    this.userVo = userVo;

    /// set Date List
    movieDateList = dummyMovieChooseDates;
    notifyListeners();

    /// First Date Selected
    movieDateList?.forEach((movie) {
      if (movie.isSelected == true) {
        movie.isSelected = false;
      }
    });

    movieChooseDateVo = movieDateList?.first;
    movieChooseDateVo?.isSelected = true;
    print(movieChooseDateVo);

    /// Get Cinemas From Database by Date
    getCinemasFromDatabaseByDate(userVo, movieId, movieChooseDateVo);
  }

  void getCinemasFromDatabaseByDate(UserVO? userVo, int movieId, MovieChooseDateVO? movieDate) {
    movieModel
        .getCinemasFromDatabase(
      userVo?.token ?? "",
      movieId.toString(),
      (movieDate?.isSelected ?? false)
          ? (movieDate?.dateTime.toString() ?? "").substring(0, 10)
          : "",
    )
        .listen((cinemas) {
      cinemaList = cinemas;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });
  }

  void onTapDate(MovieChooseDateVO movieChooseDate, int movieId) {
    movieDateList = movieDateList?.map((date) {
      if(date.isSelected == true) {
        date.isSelected = false;
      }

      if(date == movieChooseDate) {
        date.isSelected = true;
      }
      return date;
    }).toList();
    notifyListeners();
    getCinemasFromDatabaseByDate(userVo, movieId, movieChooseDate);
  }

  void onTapCinemaTimeSlot(int indexOfCinema, int indexOfTimeSlotItem) {
    cinemaList?.forEach((cinema) {
      cinema.timeSlots?.forEach((timeSlotItem) {
        timeSlotItem.isSelected = false;
      });
    });

    cinemaList = cinemaList?.map((cinema) {
      if(cinema == cinemaList?[indexOfCinema]) {
        cinema.timeSlots = cinema.timeSlots?.map((timeSlot) {
          if(timeSlot == cinemaList?[indexOfCinema].timeSlots?[indexOfTimeSlotItem]) {
            timeSlot.isSelected = true;
          }
          return timeSlot;
        }).toList();
      }
      return cinema;
    }).toList();
    notifyListeners();
  }

  CinemaVO? getSelectedCinema() {
    CinemaVO? cVo;
    cinemaList?.forEach((c) {
      c.timeSlots?.forEach((t) {
        if(t.isSelected == true) {
          cVo = c;
        }
      });
    });

    return cVo;
  }

  TimeSlotVO? getSelectedTimeSlot() {
    TimeSlotVO? tsv;
    cinemaList?.forEach((c) {
      c.timeSlots?.forEach((t) {
        if(t.isSelected == true) {
          tsv = t;
        }
      });
    });
    return tsv;
  }

  MovieChooseDateVO? getSelectedDate() {
    MovieChooseDateVO? movieChooseDate;
    movieDateList?.forEach((md) {
      if (md.isSelected == true) {
        movieChooseDate = md;
      }
    });

    return movieChooseDate;
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if(!_dispose) {
      super.notifyListeners();
    }
  }
}
