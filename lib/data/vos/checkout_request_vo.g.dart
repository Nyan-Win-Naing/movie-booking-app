// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_request_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutRequest _$CheckoutRequestFromJson(Map<String, dynamic> json) =>
    CheckoutRequest(
      json['cinema_day_timeslot_id'] as int,
      json['row'] as String,
      json['seat_number'] as String,
      json['booking_date'] as String,
      json['total_price'] as int,
      json['movie_id'] as int,
      json['card_id'] as int,
      json['cinema_id'] as int,
      (json['snacks'] as List<dynamic>)
          .map((e) => SnackRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckoutRequestToJson(CheckoutRequest instance) =>
    <String, dynamic>{
      'cinema_day_timeslot_id': instance.cinemaDayTimeslotId,
      'row': instance.row,
      'seat_number': instance.seatNumber,
      'booking_date': instance.bookingDate,
      'total_price': instance.totalPrice,
      'movie_id': instance.movieId,
      'card_id': instance.cardId,
      'cinema_id': instance.cinemaId,
      'snacks': instance.snacks,
    };
