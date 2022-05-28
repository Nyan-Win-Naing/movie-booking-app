import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    movieModel
        .getProfileFromDatabase(userVo?.token ?? "")
        .listen((userVo) {
      this.userVo = userVo;
      notifyListeners();
      print("User vo in payment bloc constructor: ${this.userVo}..........");
      cardLength = userVo?.cards?.length ?? 0;
      if (cardLength > 0) {
        cardVo = userVo?.cards?.first;
        notifyListeners();
      }
      print("Card vo in payment bloc constructor is : $cardVo");
    }).onError((error) {
      debugPrint(error.toString());
    });
  }

  void onChangeCard(CardVO? cardVo) {
    this.cardVo = cardVo;
    notifyListeners();
  }

  void onTapCard(CardVO cardVo) {
    List<CardVO> cardList = userVo?.cards?.map((card) {
      card.isSelected = false;
      if(cardVo.id == card.id) {
        cardVo.isSelected = true;
        card = cardVo;
      }
      return card;
    }).toList() ?? [];

    this.userVo = UserVO(userVo?.id, userVo?.name, userVo?.email, userVo?.phoneNumber, userVo?.totalExpense, userVo?.profileImage, cardList);
    notifyListeners();
    this.cardVo = cardVo;
    notifyListeners();
  }

  Future<VoucherVO?> onTapPurchase(
    String token,
    int paymentAmount,
    UserVO? userVo,
    TimeSlotVO? timeSlotVo,
    List<CinemaSeatVO>? selectSeats,
    MovieChooseDateVO? movieDate,
    int movieId,
    CinemaVO? cinemaVo,
    List<SnackVO>? snackList,
    CardVO? cardVo,
  ) {
    return movieModel.postCheckout(token, paymentAmount, userVo, timeSlotVo, selectSeats, movieDate, movieId, cinemaVo, snackList, cardVo,)
        .then((voucher) {
          print("Voucher In Bloc: $voucher");
          return Future.value(voucher);
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
