import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/movie_seats_bloc.dart';
import 'package:movie_booking_app/config/config_values.dart';
import 'package:movie_booking_app/config/environment_config.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_seat_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/dummy/dummy_data.dart';
import 'package:movie_booking_app/pages/snack_page.dart';
import 'package:movie_booking_app/resources/back_action.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:movie_booking_app/viewitems/movie_seat_item_view.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:provider/provider.dart';

class MovieSeatsPage extends StatelessWidget {
  final int movieId;
  final String cinemaName;
  final TimeSlotVO? timeSlotVo;
  final MovieChooseDateVO? movieDate;
  final UserVO? userVo;
  final CinemaVO? cinemaVo;

  MovieSeatsPage({
    required this.movieId,
    required this.cinemaName,
    required this.timeSlotVo,
    required this.movieDate,
    required this.userVo,
    required this.cinemaVo,
  });

  final List<MovieSeatVO> _movieSeats = dummyMovieSeats;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieSeatsBloc(
          movieId, cinemaName, timeSlotVo, movieDate, userVo, cinemaVo),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
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
                Selector<MovieSeatsBloc, String>(
                  selector: (context, bloc) => bloc.movieName ?? "",
                  builder: (context, movieName, child) =>
                      MovieNameTimeAndCinemaSectionView(
                    movieName: movieName,
                    cinemaName: cinemaName,
                    movieDate: movieDate,
                    movieCinemaTime: timeSlotVo?.startTime ?? "",
                  ),
                ),
                const SizedBox(height: MARGIN_LARGE),
                Selector<MovieSeatsBloc, List<CinemaSeatVO>>(
                  selector: (context, bloc) => bloc.seats ?? [],
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, seats, child) => MovieSeatsSectionView(
                    movieSeats: seats,
                    // refreshAfterSelect: (CinemaSeatVO cinemaSeatVo) {
                    //   setState(() {
                    //     if (cinemaSeatVo.isSelected == true) {
                    //       _selectedSeats?.add(cinemaSeatVo);
                    //     } else {
                    //       _selectedSeats?.remove(cinemaSeatVo);
                    //     }
                    //
                    //     if(_selectedSeats!.length > 0) {
                    //       ticketPrice = _selectedSeats
                    //           ?.map((s) => s.price ?? 0)
                    //           .toList()
                    //           .reduce((value, element) => value + element);
                    //     } else {
                    //       ticketPrice = 0;
                    //     }
                    //   });
                    // },
                  ),
                ),
                const SizedBox(height: MARGIN_MEDIUM_2),
                MovieSeatsGlosarySectionView(),
                const SizedBox(height: MARGIN_LARGE),
                DottedLineSectionView(),
                const SizedBox(height: MARGIN_LARGE),
                Selector<MovieSeatsBloc, List<CinemaSeatVO>>(
                  selector: (context, bloc) => bloc.selectedSeats ?? [],
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, selectedSeats, child) =>
                      NumberOfSeatsAndTicketsSectionView(
                          selectedSeats: selectedSeats),
                ),
                const SizedBox(height: MARGIN_XLARGE),
                Selector<MovieSeatsBloc, List<CinemaSeatVO>>(
                  selector: (context, bloc) => bloc.selectedSeats ?? [],
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, selectedSeats, child) =>
                      Selector<MovieSeatsBloc, int>(
                        selector: (context, bloc) => bloc.ticketPrice ?? 0,
                        builder: (context, ticketPrice, child) {
                          return Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                            child: CommonButtonView(
                              "Buy ticket for \$${ticketPrice}",
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SnackPage(
                                      userVo: userVo,
                                      price: ticketPrice,
                                      timeSlotVo: timeSlotVo,
                                      selectSeats: selectedSeats,
                                      movieDate: movieDate,
                                      movieId: movieId,
                                      cinemaVo: cinemaVo,
                                    ),
                                  ),
                                );
                                //     print("Selected Seats are $selectedSeats....... and ticket price is $ticketPrice..........");
                              },
                            ),
                          );
                        } ,
                      ),
                ),
                const SizedBox(height: MARGIN_XLARGE),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MovieSeatsSectionView extends StatefulWidget {
  const MovieSeatsSectionView({
    Key? key,
    required List<CinemaSeatVO>? movieSeats,
    // required Function(CinemaSeatVO) refreshAfterSelect,
  })  : _movieSeats = movieSeats,
        // _refreshAfterSelect = refreshAfterSelect,
        super(key: key);

  final List<CinemaSeatVO>? _movieSeats;
  // final Function(CinemaSeatVO) _refreshAfterSelect;

  @override
  State<MovieSeatsSectionView> createState() => _MovieSeatsSectionViewState();
}

class _MovieSeatsSectionViewState extends State<MovieSeatsSectionView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget._movieSeats?.length ?? 0,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_SMALL),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 14,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // if (widget._movieSeats?[index].type == "available") {
            //   if (widget._movieSeats?[index].isSelected == true) {
            //     widget._movieSeats?[index].isSelected = false;
            //   } else {
            //     widget._movieSeats?[index].isSelected = true;
            //   }
            // }
            // widget._refreshAfterSelect(
            //     widget._movieSeats?[index] ?? CinemaSeatVO(0, "", "", "", 0));
            /// onTap seat method from Movie Seats Bloc
            MovieSeatsBloc bloc =
                Provider.of<MovieSeatsBloc>(context, listen: false);
            bloc.onTapSeat(index);
          },
          child: MovieSeatItemView(mMovieSeatVO: widget._movieSeats?[index]),
        );
      },
    );
  }
}

class NumberOfSeatsAndTicketsSectionView extends StatelessWidget {
  final List<CinemaSeatVO>? selectedSeats;

  NumberOfSeatsAndTicketsSectionView({required this.selectedSeats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        children: [
          NumberOfTicketsAndSeatsView(
            mTitle: LABEL_TICKETS,
            mInfo: "${selectedSeats?.length}",
          ),
          const SizedBox(height: MARGIN_MEDIUM),
          NumberOfTicketsAndSeatsView(
            mTitle: LABEL_SEATS,
            mInfo:
                "${selectedSeats?.map((s) => s.seatName).toList().join(", ")}",
          ),
        ],
      ),
    );
  }
}

class NumberOfTicketsAndSeatsView extends StatelessWidget {
  final String mTitle;
  final String mInfo;

  NumberOfTicketsAndSeatsView({required this.mTitle, required this.mInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          mTitle,
          style: const TextStyle(
            color: SUBSCRIPTION_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
        const Spacer(),
        Text(
          mInfo,
          style: const TextStyle(
            color: SUBSCRIPTION_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ],
    );
  }
}

class DottedLineSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: DottedLine(
        direction: Axis.horizontal,
        lineLength: double.infinity,
        lineThickness: 1.0,
        dashLength: 10.0,
        dashColor: SUBSCRIPTION_TEXT_COLOR,
        dashGapLength: 8.0,
      ),
    );
  }
}

class MovieSeatsGlosarySectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MovieSeatGlosaryView(
              MOVIE_SEAT_AVAILABLE_COLOR,
              LABEL_AVAILABLE,
            ),
          ),
          Expanded(
            flex: 1,
            child: MovieSeatGlosaryView(
              MOVIE_SEAT_TAKEN_COLOR,
              LABEL_TAKEN,
            ),
          ),
          Expanded(
            flex: 1,
            child: MovieSeatGlosaryView(
              THEME_COLORS[EnvironmentConfig.CONFIG_THEME_COLOR] ?? Colors.white,
              LABEL_YOUR_SELECTION,
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSeatGlosaryView extends StatelessWidget {
  final Color glosaryColor;
  final String glosaryLabel;

  MovieSeatGlosaryView(this.glosaryColor, this.glosaryLabel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: glosaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: MARGIN_SMALL),
        Text(
          glosaryLabel,
          style: TextStyle(
            fontSize: TEXT_SMALL,
          ),
        ),
      ],
    );
  }
}

class MovieNameTimeAndCinemaSectionView extends StatelessWidget {
  String movieName;
  String cinemaName;
  String movieCinemaTime;
  MovieChooseDateVO? movieDate;

  MovieNameTimeAndCinemaSectionView({
    required this.movieName,
    required this.cinemaName,
    required this.movieCinemaTime,
    required this.movieDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          movieName,
          style: TextStyle(
            color: Colors.black,
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: MARGIN_SMALL),
        Text(
          cinemaName,
          style: TextStyle(
            color: SUBSCRIPTION_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
        SizedBox(height: MARGIN_SMALL),
        Text(
          "${movieDate?.dayName}, ${movieDate?.dateTime.day} / ${movieDate?.dateTime.month}, ${movieCinemaTime}",
          style: TextStyle(
            color: SUBSCRIPTION_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ],
    );
  }
}
