import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';

class PaymentBloc extends ChangeNotifier {
  /// States
  UserVO? userVo;
  CardVO? cardVo;
  VoucherVO? voucherVo;

  /// Models
  MovieModel movieModel = MovieModelImpl();

  PaymentBloc(
    int paymentAmount,
    UserVO? userVo,
    TimeSlotVO? timeSlotVo,
    List<CinemaSeatVO>? selectedSeats,
    MovieChooseDateVO? movieDate,
    int movieId,
    CinemaVO? cinemaVo,
    List<SnackVO>? snackList,
  ) {
    /// Get Profile from Database
    int cardLength = 0;
    movieModel.getProfileFromDatabase(userVo?.token ?? "")
    .listen((userVo) {
      this.userVo = userVo;
      notifyListeners();
      cardLength = userVo?.cards?.length ?? 0;
      if(cardLength > 0) {
        cardVo = userVo?.cards?.first;
        notifyListeners();
      }
    }).onError((error) {
      debugPrint(error.toString());
    });
  }

  void onChangeCard(CardVO? cardVo) {
    this.cardVo = cardVo;
    notifyListeners();
  }
}
