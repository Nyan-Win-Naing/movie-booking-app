import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

class MovieSeatsBloc extends ChangeNotifier {
  /// States
  String? movieName;
  List<CinemaSeatVO>? seats;
  List<CinemaSeatVO>? selectedSeats = [];
  int? ticketPrice = 0;

  /// Model
  MovieModel movieModel = MovieModelImpl();

  MovieSeatsBloc(int movieId, String cinemaName, TimeSlotVO? timeSlotVo,
      MovieChooseDateVO? movieDate, UserVO? userVo, CinemaVO? cinemaVo) {
    /// Movie Details from Database and Set Movie Name
    movieModel.getMovieDetailsFromDatabase(movieId).listen((movie) {
      movieName = movie?.title;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Get Cinema Seats
    movieModel
        .getCinemaSeats(
            userVo?.token ?? "",
            timeSlotVo?.timeslotId.toString() ?? "",
            (movieDate?.dateTime.toString() ?? "").substring(0, 10))
        .then((seatList) {
      seats = seatList;
      notifyListeners();
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void onTapSeat(int index) {
    /// Set Cinema Seat VO isSelected
    CinemaSeatVO clickedSeat = seats?[index] ?? CinemaSeatVO(0, "", "", "", 0);
    if (clickedSeat.type == "available") {
      if (clickedSeat.isSelected == true) {
        clickedSeat.isSelected = false;
      } else {
        clickedSeat.isSelected = true;
      }
    }

    seats = List.of(seats ?? []);
    notifyListeners();

    /// Add or Remove from Selected Seats List
    addOrRemoveFromSelectedSeats(clickedSeat);
  }

  void addOrRemoveFromSelectedSeats(CinemaSeatVO clickedSeat) {
    if (clickedSeat.isSelected == true) {
      selectedSeats?.add(clickedSeat);
    } else {
      selectedSeats?.remove(clickedSeat);
    }
    selectedSeats = List.of(selectedSeats ?? []);
    notifyListeners();

    /// Calculate Ticket Price from Selected Seat List
    calculateTicketPrice();
  }

  void calculateTicketPrice() {
    if ((selectedSeats?.length ?? 0) > 0) {
      ticketPrice = selectedSeats
          ?.map((s) => s.price ?? 0)
          .toList()
          .reduce((value, element) => value + element);
      notifyListeners();
    } else {
      ticketPrice = 0;
      notifyListeners();
    }
  }
}
