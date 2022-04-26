import 'package:movie_booking_app/utils/constants.dart';

class MovieSeatVO {
  String type;
  String title;

  MovieSeatVO({required this.type, required this.title});

  bool isMovieSeatAvailable() {
    return type == SEAT_TYPE_AVAILABLE;
  }

  bool isMovieSeatTaken() {
    return type == SEAT_TYPE_TAKEN;
  }

  bool isMovieSeatRowTitle() {
    return type == SEAT_TYPE_TEXT;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieSeatVO &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title;

  @override
  int get hashCode => type.hashCode ^ title.hashCode;
}