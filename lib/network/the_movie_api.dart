import 'package:dio/dio.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/network/responses/get_credits_by_movie_response.dart';
import 'package:movie_booking_app/network/responses/get_genres_response.dart';
import 'package:movie_booking_app/network/responses/get_time_slot_response.dart';
import 'package:movie_booking_app/network/responses/movie_list_response.dart';
import 'package:retrofit/http.dart';

part 'the_movie_api.g.dart';

@RestApi(baseUrl: MOVIE_DB_BASE_URL_DIO)
abstract class TheMovieApi {
  factory TheMovieApi(Dio dio) = _TheMovieApi;

  @GET(ENDPOINT_GET_NOW_PLAYING)
  Future<MovieListResponse> getNowPlayingMovies(
    @Query(PARAM_API_KEY) String apiKey,
    @Query(PARAM_LANGUAGE) String language,
    @Query(PARAM_PAGE) String page,
  );

  @GET(ENDPOINT_COMING_SOON)
  Future<MovieListResponse> getUpcomingMovies(
    @Query(PARAM_API_KEY) String apiKey,
    @Query(PARAM_LANGUAGE) String language,
    @Query(PARAM_PAGE) String page,
  );

  @GET(ENDPOINT_GET_GENRES)
  Future<GetGenresResponse> getGenres(
    @Query(PARAM_API_KEY) String apiKey,
    @Query(PARAM_LANGUAGE) String language,
  );

  @GET("$ENDPOINT_GET_MOVIE_DETAILS/{movie_id}")
  Future<MovieVO?> getMovieDetails(
    @Path("movie_id") String movieId,
    @Query(PARAM_API_KEY) String apiKey,
    @Query(PARAM_LANGUAGE) String language,
  );

  @GET("/3/movie/{movie_id}/credits")
  Future<GetCreditsByMovieResponse> getCreditsByMovie(
    @Path("movie_id") String movieId,
    @Query(PARAM_API_KEY) String apiKey,
    @Query(PARAM_LANGUAGE) String language,
  );
}
