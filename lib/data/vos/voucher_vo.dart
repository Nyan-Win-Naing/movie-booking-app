import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';

part 'voucher_vo.g.dart';

@JsonSerializable()
class VoucherVO {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "booking_no")
  String? bookingNumber;

  @JsonKey(name: "booking_date")
  String? bookingDate;

  @JsonKey(name: "row")
  String? row;

  @JsonKey(name: "seat")
  String? seat;

  @JsonKey(name: "total_seat")
  int? totalSeat;

  @JsonKey(name: "total")
  String? total;

  @JsonKey(name: "movie_id")
  int? movieId;

  @JsonKey(name: "cinema_id")
  int? cinemaId;

  @JsonKey(name: "username")
  String? username;

  @JsonKey(name: "timeslot")
  TimeSlotVO? timeSlot;

  @JsonKey(name: "snacks")
  List<SnackVO>? snacks;

  @JsonKey(name: "qr_code")
  String? qrCode;

  VoucherVO(
    this.id,
    this.bookingNumber,
    this.bookingDate,
    this.row,
    this.seat,
    this.totalSeat,
    this.total,
    this.movieId,
    this.cinemaId,
    this.username,
    this.timeSlot,
    this.snacks,
    this.qrCode,
  );

  factory VoucherVO.fromJson(Map<String, dynamic> json) => _$VoucherVOFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherVOToJson(this);

  @override
  String toString() {
    return 'VoucherVO{id: $id, bookingNumber: $bookingNumber, bookingDate: $bookingDate, row: $row, seat: $seat, totalSeat: $totalSeat, total: $total, movieId: $movieId, cinemaId: $cinemaId, username: $username, timeSlot: $timeSlot, snacks: $snacks, qrCode: $qrCode}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoucherVO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingNumber == other.bookingNumber &&
          bookingDate == other.bookingDate &&
          row == other.row &&
          seat == other.seat &&
          totalSeat == other.totalSeat &&
          total == other.total &&
          movieId == other.movieId &&
          cinemaId == other.cinemaId &&
          username == other.username &&
          timeSlot == other.timeSlot &&
          snacks == other.snacks &&
          qrCode == other.qrCode;

  @override
  int get hashCode =>
      id.hashCode ^
      bookingNumber.hashCode ^
      bookingDate.hashCode ^
      row.hashCode ^
      seat.hashCode ^
      totalSeat.hashCode ^
      total.hashCode ^
      movieId.hashCode ^
      cinemaId.hashCode ^
      username.hashCode ^
      timeSlot.hashCode ^
      snacks.hashCode ^
      qrCode.hashCode;
}
