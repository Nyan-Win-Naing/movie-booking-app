import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/snack_request.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/pages/home_page.dart';
import 'package:movie_booking_app/resources/back_action.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:barcode_widget/barcode_widget.dart';

class VoucherPage extends StatefulWidget {
  // final int paymentAmount;
  // final UserVO? userVo;
  //
  // final TimeSlotVO? timeSlotVo;
  // final List<CinemaSeatVO>? selectSeats;
  // final MovieChooseDateVO? movieDate;
  // final int movieId;
  // final CinemaVO? cinemaVo;
  // final List<SnackVO>? snackList;
  // final CardVO? cardVo;
  //
  // VoucherPage({
  //   required this.paymentAmount,
  //   required this.userVo,
  //   required this.timeSlotVo,
  //   required this.selectSeats,
  //   required this.movieDate,
  //   required this.movieId,
  //   required this.cinemaVo,
  //   required this.snackList,
  //   required this.cardVo,
  // });

  final int movieId;
  final UserVO? userVo;
  final CinemaVO? cinemaVo;
  final VoucherVO? voucherVo;

  VoucherPage({
    required this.movieId,
    required this.userVo,
    required this.cinemaVo,
    required this.voucherVo,
  });

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  /// Movie Model
  MovieModel _movieModel = MovieModelImpl();

  /// State Variables
  VoucherVO? voucherVo;
  MovieVO? movieVo;

  @override
  void initState() {
    // Set<String> selectedRows = {};
    //
    // widget.selectSeats?.forEach((seat) {
    //   selectedRows.add(seat.symbol ?? "");
    // });
    //
    // String? selectedSeats =
    //     widget.selectSeats?.map((s) => s.seatName).toList().join(", ");
    //
    // List<SnackRequest>? snackRequestList = widget.snackList?.map((snack) {
    //   return SnackRequest(snack.id ?? 0, snack.quantity ?? 0);
    // }).toList();
    //
    // print("Cinema TimeSlot id: ${widget.timeSlotVo?.timeslotId},"
    //     " row: ${selectedRows.toList().join(",")},"
    //     " seatNumber: $selectedSeats,"
    //     " bookingDate: ${widget.movieDate?.dateTime.toString().substring(0, 10)},"
    //     " total price: ${widget.paymentAmount},"
    //     " movieId: ${widget.movieId},"
    //     " cardId: ${widget.cardVo?.id},"
    //     " cinemaId: ${widget.cinemaVo?.cinemaId},"
    //     " snacks: $snackRequestList");

    // _movieModel.getMovieDetails(widget.movieId).then((movie) {
    //   setState(() {
    //     movieVo = movie;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });
    /// Movie Details From Database
    _movieModel.getMovieDetailsFromDatabase(widget.movieId).listen((movie) {
      setState(() {
        movieVo = movie;
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Set voucher state
    voucherVo = widget.voucherVo;
    // _movieModel
    //     .postCheckout(
    //         "Bearer ${widget.userVo?.token}",
    //         widget.paymentAmount,
    //         widget.userVo,
    //         widget.timeSlotVo,
    //         widget.selectSeats,
    //         widget.movieDate,
    //         widget.movieId,
    //         widget.cinemaVo,
    //         widget.snackList,
    //         widget.cardVo)
    //     .then((voucher) {
    //   setState(() {
    //     voucherVo = voucher;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    //   print(error);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(voucherVo);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(userId: widget.userVo?.id ?? 0)));
          },
          child: const Icon(
            Icons.close,
            color: Colors.black,
            size: MARGIN_XLARGE,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              VoucherTitleSectionView(),
              const SizedBox(height: MARGIN_MEDIUM_2),
              VoucherSectionView(
                movieVo: movieVo,
                voucherVo: voucherVo,
                cinemaVo: widget.cinemaVo,
              ),
              const SizedBox(height: MARGIN_XXLARGE),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherSectionView extends StatelessWidget {
  final MovieVO? movieVo;
  final VoucherVO? voucherVo;
  final CinemaVO? cinemaVo;

  VoucherSectionView(
      {required this.movieVo, required this.voucherVo, required this.cinemaVo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 1, // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          MovieImageAndTitleView(
            movieVo: movieVo,
          ),
          DottedLineDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: MARGIN_LARGE, horizontal: MARGIN_MEDIUM_2),
            child: AboutFilmSectionView(
              voucherVo: voucherVo,
              cinemaVo: cinemaVo,
            ),
          ),
          DottedLineDivider(),
          VoucherBarcodeSectionView(
            voucher: voucherVo,
          ),
        ],
      ),
    );
  }
}

class VoucherBarcodeSectionView extends StatelessWidget {
  final VoucherVO? voucher;

  VoucherBarcodeSectionView({required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: MARGIN_LARGE),
      child: BarcodeWidget(
        barcode: Barcode.code128(),
        data: voucher?.qrCode ?? "",
        height: 100,
        width: 250,
      ),
    );
  }
}

class AboutFilmSectionView extends StatelessWidget {
  final VoucherVO? voucherVo;
  final CinemaVO? cinemaVo;

  AboutFilmSectionView({required this.voucherVo, required this.cinemaVo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AboutFilmInfoView("Booking no", voucherVo?.bookingNumber ?? ""),
        const SizedBox(height: MARGIN_XLARGE),
        AboutFilmInfoView("Show time - Date",
            "${voucherVo?.timeSlot?.startTime} - ${voucherVo?.bookingDate}"),
        const SizedBox(height: MARGIN_XLARGE),
        AboutFilmInfoView("Theater", cinemaVo?.cinema ?? ""),
        const SizedBox(height: MARGIN_XLARGE),
        AboutFilmInfoView("Row", voucherVo?.row ?? ""),
        const SizedBox(height: MARGIN_XLARGE),
        AboutFilmInfoView("Seats", voucherVo?.seat ?? ""),
        const SizedBox(height: MARGIN_XLARGE),
        AboutFilmInfoView("Price", voucherVo?.total ?? ""),
      ],
    );
  }
}

class AboutFilmInfoView extends StatelessWidget {
  final String title;
  final String label;

  AboutFilmInfoView(this.title, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: SUBSCRIPTION_TEXT_COLOR,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class DottedLineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 10.0,
      dashColor: SUBSCRIPTION_TEXT_COLOR,
      dashGapLength: 8.0,
    );
  }
}

class MovieImageAndTitleView extends StatelessWidget {
  final MovieVO? movieVo;

  MovieImageAndTitleView({required this.movieVo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoucherMovieView(
          moviePhoto: movieVo?.posterPath ?? "",
        ),
        const SizedBox(height: MARGIN_MEDIUM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: MovieNameSectionView(
            movieName: movieVo?.title ?? "",
          ),
        ),
      ],
    );
  }
}

class MovieNameSectionView extends StatelessWidget {
  final String movieName;

  MovieNameSectionView({required this.movieName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movieName,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_3X,
          ),
        ),
        const SizedBox(height: MARGIN_MEDIUM),
        const Text(
          "105m - IMAX",
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: SUBSCRIPTION_TEXT_COLOR,
          ),
        ),
        const SizedBox(height: MARGIN_LARGE),
      ],
    );
  }
}

class VoucherMovieView extends StatelessWidget {
  final String moviePhoto;

  VoucherMovieView({required this.moviePhoto});

  @override
  Widget build(BuildContext context) {
    return moviePhoto != ""
        ? Container(
            height: MediaQuery.of(context).size.height / 4.8,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(MARGIN_CARD_MEDIUM_2),
              ),
              image: DecorationImage(
                image: NetworkImage("$IMAGE_BASE_URL$moviePhoto"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 4.8,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

class VoucherTitleSectionView extends StatelessWidget {
  const VoucherTitleSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: MARGIN_MEDIUM_2),
      child: Column(
        children: const [
          Text(
            "Awesome!",
            style: TextStyle(
              color: Colors.black,
              fontSize: TEXT_HEADING_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MARGIN_MEDIUM),
          Text(
            "This is your ticket.",
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              color: SUBSCRIPTION_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
