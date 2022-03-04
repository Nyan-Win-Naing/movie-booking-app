import 'package:dio/dio.dart';
import 'package:movie_booking_app/data/vos/checkout_request_vo.dart';
import 'package:movie_booking_app/data/vos/logout_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/network/responses/authentication_response.dart';
import 'package:movie_booking_app/network/responses/checkout_response.dart';
import 'package:movie_booking_app/network/responses/create_card_response.dart';
import 'package:movie_booking_app/network/responses/get_snack_list_response.dart';
import 'package:movie_booking_app/network/responses/get_time_slot_response.dart';
import 'package:movie_booking_app/network/responses/payment_method_response.dart';
import 'package:movie_booking_app/network/responses/seating_plan_response.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: PADC_BASE_URL_DIO)
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @POST(ENDPOINT_POST_REGISTER_WITH_EMAIL)
  @FormUrlEncoded()
  Future<AuthenticationResponse> postUserRegistration(
    @Field("name") String name,
    @Field("email") String email,
    @Field("phone") String phone,
    @Field("password") String password,
    @Field("google-access-token") String? googleToken,
    @Field("facebook-access-token") String? facebookToken,
  );

  @POST(ENDPOINT_POST_LOGIN_WITH_EMAIL)
  @FormUrlEncoded()
  Future<AuthenticationResponse> postUserLogin(
    @Field("email") String email,
    @Field("password") String password,
  );

  @POST(ENDPOINT_POST_LOGIN_GOOGLE)
  @FormUrlEncoded()
  Future<AuthenticationResponse> postUserLoginWithGoogle(
    @Field("access-token") String gToken,
  );

  @POST(ENDPOINT_POST_LOGIN_FACEBOOK)
  @FormUrlEncoded()
  Future<AuthenticationResponse> postUserLoginWithFacebook(
    @Field("access-token") String fbToken,
  );

  @POST(ENDPOINT_LOGOUT)
  Future<LogoutVO> logout(@Header("Authorization") String authToken);

  @GET(ENDPOINT_GET_MOVIE_TIMESLOT)
  Future<GetTimeSlotResponse> getTimeSlotResponse(
    @Header("Authorization") String token,
    @Header("Accept") String appType,
    @Query("movie_id") String movieId,
    @Query("date") String date,
  );

  @GET(ENDPOINT_GET_SEATING_PLAN)
  Future<SeatingPlanResponse> getSeatingPlanResponse(
    @Header("Authorization") String userToken,
    @Query(PARAM_CINEMA_TIMESLOT_ID) String timeSlotId,
    @Query(PARAM_BOOKING_DATE) String bookingDate,
  );

  @GET(ENDPOINT_GET_SNACK_LIST)
  Future<GetSnackListResponse> getSnackListResponse(
    @Header("Authorization") String userToken,
  );

  @GET(ENDPOINT_GET_PAYMENT_METHOD)
  Future<PaymentMethodResponse> getPaymentMethodResponse(
    @Header("Authorization") String userToken,
  );

  @GET(ENDPOINT_PROFILE)
  Future<AuthenticationResponse> getProfileResponse(
    @Header("Authorization") String userToken,
  );

  @POST(ENDPOINT_POST_CREATE_CARD)
  @FormUrlEncoded()
  Future<CreateCardResponse> postCreateCardResponse(
    @Header("Authorization") String userToken,
    @Field("card_number") String cardNumber,
    @Field("card_holder") String cardHolder,
    @Field("expiration_date") String expireDate,
    @Field("cvc") String cvc,
  );

  @POST(ENDPOINT_POST_CHECKOUT)
  Future<CheckoutResponse> postCheckout(
    @Header("Authorization") String token,
    @Body() CheckoutRequest checkoutRequest,
  );
}
