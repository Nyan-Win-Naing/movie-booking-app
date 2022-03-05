import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/resources/back_action.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/show_alert_dialog.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:movie_booking_app/widgets/form_style_view.dart';

class PaymentFormPage extends StatefulWidget {
  final UserVO? userVo;
  final Function refreshPaymentPageCards;

  PaymentFormPage({
    required this.userVo,
    required this.refreshPaymentPageCards,
  });

  @override
  State<PaymentFormPage> createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> {
  /// Model
  MovieModel _movieModel = MovieModelImpl();

  final TextEditingController cNumberController = TextEditingController();

  final TextEditingController cHolderController = TextEditingController();

  final TextEditingController cExpireController = TextEditingController();

  final TextEditingController cCvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          PAYMENT_FORM_TITLE,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            widget.refreshPaymentPageCards();
            backAction(context);
          },
          child: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: MARGIN_XXLARGE,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: MARGIN_XXLARGE),
              PaymentFormSectionView(
                cnc: cNumberController,
                chc: cHolderController,
                cec: cExpireController,
                ccc: cCvcController,
              ),
              const SizedBox(height: MARGIN_XLARGE),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                child: CommonButtonView(
                  "Confirm",
                  () {
                    print("Tap Tap");
                    _movieModel
                        .postCreateCard(
                            "${widget.userVo?.token}",
                            cNumberController.text,
                            cHolderController.text,
                            cExpireController.text,
                            cCvcController.text)
                        .then((cardList) {
                      showAlertDialog(context, "Account Create Successfully");

                      _movieModel
                          .getProfileFromDatabase("${widget.userVo?.token}")
                          .listen((userVo) {
                        print("It works......");
                      }).onError((error) {
                        debugPrint(error.toString());
                      });
                    }).catchError((error) {
                      debugPrint(error.toString());
                    });

                                      },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFormSectionView extends StatelessWidget {
  final TextEditingController cnc;
  final TextEditingController chc;
  final TextEditingController cec;
  final TextEditingController ccc;

  PaymentFormSectionView({
    required this.cnc,
    required this.chc,
    required this.cec,
    required this.ccc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        children: [
          FormStyleView(
            CARD_NUMBER,
            CARD_NUMBER_HINT_TEXT,
            isNumber: true,
            textController: cnc,
          ),
          const SizedBox(height: MARGIN_MEDIUM_3),
          FormStyleView(
            CARD_HOLDER,
            CARD_HOLDER_HINT_TEXT,
            textController: chc,
          ),
          const SizedBox(height: MARGIN_MEDIUM_3),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: FormStyleView(
                  EXPIRED_DATE,
                  EXPIRED_DATE_HINT_TEXT,
                  textController: cec,
                ),
              ),
              const SizedBox(width: MARGIN_MEDIUM_2),
              Expanded(
                flex: 1,
                child: FormStyleView(
                  "CVC",
                  "Enter cvc",
                  isNumber: true,
                  textController: ccc,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
