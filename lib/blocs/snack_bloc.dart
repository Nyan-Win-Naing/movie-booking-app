import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

class SnackBloc extends ChangeNotifier {
  /// States
  List<SnackVO>? snacks;
  List<PaymentMethodVO>? paymentMethods;
  int price = 0;
  List<SnackVO>? selectedSnacks;

  /// Model
  MovieModel movieModel = MovieModelImpl();

  SnackVO? clickedSnack;

  SnackBloc(
    UserVO? userVo,
    int price,
    TimeSlotVO? timeSlotVo,
    List<CinemaSeatVO>? selectedSeats,
    MovieChooseDateVO? movieDate,
    int movieId,
    CinemaVO? cinemaVo,
  ) {
    this.price = price;

    /// Get Snacks From Database
    movieModel.getSnacksFromDatabase(userVo?.token ?? "").listen((snackList) {
      snacks = snackList;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Get Payment Methods From Database
    movieModel.getPaymentMethodsFromDatabase(userVo?.token ?? "").listen((paymentMethods) {
      this.paymentMethods = paymentMethods;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });
  }

  SnackVO? onTapPlus(SnackVO snackVo) {
    this.snacks = snacks?.map((snack) {
      if(snack == snackVo) {
        snack.quantity = (snack.quantity ?? 0) + 1;
        changePrice(snack, 1, "plus");
      }
      return snack;
    }).toList();
    notifyListeners();
    return clickedSnack;
  }

  void onTapMinus(SnackVO snackVo) {
    if((snackVo.quantity ?? 0) != 0) {
      this.snacks = snacks?.map((snack) {
        if(snack == snackVo) {
          snack.quantity = (snack.quantity ?? 0) - 1;
          changePrice(snack, 1, "minus");
        }
        return snack;
      }).toList();
      notifyListeners();
    }
  }

  void changePrice(SnackVO snackVo, int count, String operator) {
    print("Snack ID: ${snackVo.id}, Item count: ${snackVo.quantity}..........");
    int clickedSnackPrice = snackVo.price ?? 0;
    if(operator == "plus") {
      int eachTotalPrice = clickedSnackPrice * count;
      this.price = price + eachTotalPrice;
    } else {
      this.price -= clickedSnackPrice;
    }
  }

  List<SnackVO> getAllSelectedSnacks() {
    selectedSnacks = snacks?.map((snack) => snack).where((snack) {
      int q = snack.quantity ?? 0;
      return q > 0;
    }).toList();
    return selectedSnacks ?? [];
  }
}
