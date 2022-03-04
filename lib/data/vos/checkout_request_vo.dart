import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/snack_request.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';

part 'checkout_request_vo.g.dart';

@JsonSerializable()
class CheckoutRequest {
  @JsonKey(name: "cinema_day_timeslot_id")
  int cinemaDayTimeslotId;

  @JsonKey(name: "row")
  String row;

  @JsonKey(name: "seat_number")
  String seatNumber;

  @JsonKey(name: "booking_date")
  String bookingDate;

  @JsonKey(name: "total_price")
  int totalPrice;

  @JsonKey(name: "movie_id")
  int movieId;

  @JsonKey(name: "card_id")
  int cardId;

  @JsonKey(name: "cinema_id")
  int cinemaId;

  @JsonKey(name: "snacks")
  List<SnackRequest> snacks;

  CheckoutRequest(
    this.cinemaDayTimeslotId,
    this.row,
    this.seatNumber,
    this.bookingDate,
    this.totalPrice,
    this.movieId,
    this.cardId,
    this.cinemaId,
    this.snacks,
  );

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) => _$CheckoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutRequestToJson(this);

  @override
  String toString() {
    return 'CheckoutRequest{cinemaDayTimeslotId: $cinemaDayTimeslotId, row: $row, seatNumber: $seatNumber, bookingDate: $bookingDate, totalPrice: $totalPrice, movieId: $movieId, cardId: $cardId, cinemaId: $cinemaId, snacks: $snacks}';
  }
}
