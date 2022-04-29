import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/resources/show_alert_dialog.dart';

class PaymentFormBloc extends ChangeNotifier {
  /// Model
  MovieModel movieModel = MovieModelImpl();

  PaymentFormBloc(UserVO? userVo) {}

  void onTapConfirm(
    UserVO? userVo,
    String cardNumber,
    String cardHolder,
    String cardExpire,
    String cardCvc,
      BuildContext context,
  ) {
    movieModel.postCreateCard(userVo?.token ?? "", cardNumber, cardHolder, cardExpire, cardCvc)
        .then((cardList) async {
          showAlertDialog(context, "Account Create Successfully");
          movieModel.getProfileFromDatabase(userVo?.token ?? "").listen((userVo) {
            print("It works.....");
          }).onError((error) {
            debugPrint(error.toString());
          });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
