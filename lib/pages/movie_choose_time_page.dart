import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/movie_choose_time_bloc.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/dummy/movie_choose_date_list.dart';
import 'package:movie_booking_app/pages/movie_seats_page.dart';
import 'package:movie_booking_app/resources/back_action.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:provider/provider.dart';

class MovieChooseTimePage extends StatelessWidget {
  final UserVO? userVo;
  final int movieId;

  MovieChooseTimePage({required this.userVo, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieChooseTimeBloc(userVo, movieId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ON_BOARDING_BACKGROUND_COLOR,
          leading: GestureDetector(
            onTap: () {
              backAction(context);
            },
            child: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: MARGIN_XXLARGE,
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Selector<MovieChooseTimeBloc, List<MovieChooseDateVO>>(
                  selector: (context, bloc) => bloc.movieDateList ?? [],
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, movieDateList, child) =>
                      MovieChooseDateView(
                    movieDateList: movieDateList,
                    showCinemasByDate: (movieChooseDateVo) {
                      // setState(() {});
                      print("");
                      // movieModel
                      //     .getCinemasFromDatabase(
                      //         "Bearer ${widget.userVo?.token}",
                      //         "${widget.movieId}",
                      //         movieChooseDateVo.isSelected
                      //             ? movieChooseDateVo.dateTime
                      //                 .toString()
                      //                 .substring(0, 10)
                      //             : "")
                      //     .listen((cinemas) {
                      //   setState(() {
                      //     cinemaList = cinemas;
                      //   });
                      // }).onError((error) {
                      //   // debugPrint(error.toString());
                      //   print(error);
                      // });
                      /// Cinema Database
                      // movieModel
                      //     .getCinemasFromDatabase(
                      //   "${widget.userVo?.token}",
                      //   "${widget.movieId}",
                      //   movieChooseDateVo.dateTime.toString().substring(0, 10),
                      // )
                      //     .listen((cinemas) {
                      //   if (mounted) {
                      //     setState(() {
                      //       cinemaList = cinemas ?? [];
                      //     });
                      //   }
                      // }).onError((error) {
                      //   print(error);
                      // });
                      MovieChooseTimeBloc bloc =
                          Provider.of<MovieChooseTimeBloc>(context,
                              listen: false);
                      bloc.onTapDate(movieChooseDateVo, movieId);
                    },
                  ),
                ),
                Selector<MovieChooseTimeBloc, List<CinemaVO>>(
                  selector: (context, bloc) => bloc.cinemaList ?? [],
                  shouldRebuild: (previous, next) => previous != next,
                  builder: (context, cinemaList, child) =>
                      ChooseItemGridSectionView(cinemas: cinemaList),
                ),
                const SizedBox(height: MARGIN_LARGE),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                  child: Builder(
                    builder: (context) {
                      return CommonButtonView(
                        "Next",
                            () {
                          MovieChooseTimeBloc bloc = Provider.of<MovieChooseTimeBloc>(context, listen: false);
                          String cinemaName = bloc.getSelectedCinema()?.cinema ?? "";
                          MovieChooseDateVO? movieDate = bloc.getSelectedDate();
                          TimeSlotVO? tsv = bloc.getSelectedTimeSlot();

                          // print("Cinema name: $cinemaName, Movie Date: $movieDate, Time Slot: $tsv...........");
                          // print("Selected cinema: ${bloc.getSelectedCinema()}.......");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieSeatsPage(
                                movieId: movieId,
                                cinemaName: cinemaName,
                                timeSlotVo: tsv,
                                movieDate: movieDate,
                                userVo: userVo,
                                cinemaVo: bloc.getSelectedCinema(),
                              ),
                            ),
                          );

                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseItemGridSectionView extends StatefulWidget {
  List<CinemaVO>? cinemas;

  ChooseItemGridSectionView({required this.cinemas});

  @override
  State<ChooseItemGridSectionView> createState() =>
      _ChooseItemGridSectionViewState();
}

class _ChooseItemGridSectionViewState extends State<ChooseItemGridSectionView> {
  @override
  Widget build(BuildContext context) {
    List<CinemaVO> cinemaList = widget.cinemas ?? [];

    return Container(
      padding: const EdgeInsets.only(
        top: MARGIN_MEDIUM_2,
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
      ),
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cinemaList.length,
            itemBuilder: (BuildContext context, int indexOfCinema) {
              return Padding(
                padding: EdgeInsets.only(bottom: MARGIN_XLARGE),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cinemaList[indexOfCinema].cinema ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: TEXT_REGULAR_3X,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: MARGIN_MEDIUM_2),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          cinemaList[indexOfCinema].timeSlots?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (context, indexOfTimeSlotItem) {
                        return GestureDetector(
                          onTap: () {
                            MovieChooseTimeBloc bloc =
                                Provider.of<MovieChooseTimeBloc>(context,
                                    listen: false);
                            bloc.onTapCinemaTimeSlot(
                                indexOfCinema, indexOfTimeSlotItem);
                            print(
                                "Time Slot id is : ${cinemaList[indexOfCinema].timeSlots?[indexOfTimeSlotItem].timeslotId}............");
                          },
                          child: TimeSlotItem(
                              timeSlots:
                                  cinemaList[indexOfCinema].timeSlots ?? [],
                              index: indexOfTimeSlotItem),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// class ChooseItemGridView extends StatefulWidget {
//   final CinemaVO cinemaVO;
//   final List<CinemaVO>? cinemaList;
//
//   ChooseItemGridView({required this.cinemaVO, required this.cinemaList});
//
//   @override
//   State<ChooseItemGridView> createState() => _ChooseItemGridViewState();
// }

// class _ChooseItemGridViewState extends State<ChooseItemGridView> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: MARGIN_XLARGE),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.cinemaVO.cinema ?? "",
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: TEXT_REGULAR_3X,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: MARGIN_MEDIUM_2),
//           GridView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: widget.cinemaVO.timeSlots?.length ?? 0,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 2.5,
//             ),
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   // setState(() {
//                   // widget.cinemaVO.timeSlots?.forEach((timeSlotItem) {
//                   //   timeSlotItem.isSelected = false;
//                   // });
//                   // widget.cinemaList?.forEach((cinema) {
//                   //   cinema.timeSlots?.forEach((timeSlotItem) {
//                   //     if(timeSlotItem.isSelected == true)
//                   //       timeSlotItem.isSelected = false;
//                   //   });
//                   // });
//                   // widget.cinemaVO.timeSlots?[index].isSelected = true;
//                   // });
//                 },
//                 child: TimeSlotItem(
//                     timeSlots: widget.cinemaVO.timeSlots ?? [], index: index),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class TimeSlotItem extends StatelessWidget {
  const TimeSlotItem({
    Key? key,
    required this.timeSlots,
    required this.index,
  }) : super(key: key);

  final List<TimeSlotVO> timeSlots;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
        top: MARGIN_MEDIUM,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        border: Border.all(color: Colors.grey, width: 1),
        color: (timeSlots[index].isSelected ?? false)
            ? ON_BOARDING_BACKGROUND_COLOR
            : Colors.white,
      ),
      child: Center(
        child: Text(
          // cinemaVO.timeSlots?[index].startTime ?? "",
          timeSlots[index].startTime ?? "",
          style: TextStyle(
            color: (timeSlots[index].isSelected ?? false)
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

class MovieChooseDateView extends StatefulWidget {
  List<MovieChooseDateVO> movieDateList;
  // MovieModel movieModel;
  // String userToken;
  // int movieId;
  Function(MovieChooseDateVO) showCinemasByDate;

  MovieChooseDateView({
    required this.movieDateList,
    // required this.movieModel,
    // required this.userToken,
    // required this.movieId,
    required this.showCinemasByDate,
  });

  @override
  State<MovieChooseDateView> createState() => _MovieChooseDateViewState();
}

class _MovieChooseDateViewState extends State<MovieChooseDateView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ON_BOARDING_BACKGROUND_COLOR,
      height: MOVIE_TIME_DATE_LIST_HEIGHT,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(width: MARGIN_MEDIUM_2);
        },
        padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
        scrollDirection: Axis.horizontal,
        itemCount: widget.movieDateList.length,
        itemBuilder: (context, index) {
          MovieChooseDateVO movieDate = widget.movieDateList[index];
          return GestureDetector(
            onTap: () {
              // setState(() {
              widget.movieDateList.forEach((movie) {
                if (movie.isSelected == true) {
                  movie.isSelected = false;
                }
              });
              movieDate.isSelected = true;
              widget.showCinemasByDate(movieDate);
              // });
            },
            child: DayAndDateView(movieDate: movieDate),
          );
        },
      ),
    );
  }
}

class DayAndDateView extends StatelessWidget {
  const DayAndDateView({
    Key? key,
    required this.movieDate,
  }) : super(key: key);

  final MovieChooseDateVO movieDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          movieDate.dayName.substring(0, 2),
          style: TextStyle(
            color: movieDate.isSelected
                ? Colors.white
                : Color.fromRGBO(174, 156, 244, 1.0),
            fontSize: TEXT_REGULAR_3X,
          ),
        ),
        const SizedBox(height: MARGIN_MEDIUM),
        Text(
          movieDate.dateTime.day.toString(),
          style: TextStyle(
            color: movieDate.isSelected
                ? Colors.white
                : Color.fromRGBO(174, 156, 244, 1.0),
            fontSize: TEXT_REGULAR_3X,
          ),
        ),
      ],
    );
  }
}
