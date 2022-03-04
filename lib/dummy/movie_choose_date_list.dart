import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';

final now = DateTime.now();
late String dayName;

List<MovieChooseDateVO> dummyMovieChooseDates = [
  MovieChooseDateVO(dateTime: getDay(1), isSelected: false, dayName: getDayName(getDay(1).weekday)),
  MovieChooseDateVO(dateTime: getDay(2), isSelected: false, dayName: getDayName(getDay(2).weekday)),
  MovieChooseDateVO(dateTime: getDay(3), isSelected: false, dayName: getDayName(getDay(3).weekday)),
  MovieChooseDateVO(dateTime: getDay(4), isSelected: false, dayName: getDayName(getDay(4).weekday)),
  MovieChooseDateVO(dateTime: getDay(5), isSelected: false, dayName: getDayName(getDay(5).weekday)),
  MovieChooseDateVO(dateTime: getDay(6), isSelected: false, dayName: getDayName(getDay(6).weekday)),
  MovieChooseDateVO(dateTime: getDay(7), isSelected: false, dayName: getDayName(getDay(7).weekday)),
  MovieChooseDateVO(dateTime: getDay(8), isSelected: false, dayName: getDayName(getDay(8).weekday)),
  MovieChooseDateVO(dateTime: getDay(9), isSelected: false, dayName: getDayName(getDay(9).weekday)),
  MovieChooseDateVO(dateTime: getDay(10), isSelected: false, dayName: getDayName(getDay(10).weekday)),
  MovieChooseDateVO(dateTime: getDay(11), isSelected: false, dayName: getDayName(getDay(11).weekday)),
  MovieChooseDateVO(dateTime: getDay(12), isSelected: false, dayName: getDayName(getDay(12).weekday)),
  MovieChooseDateVO(dateTime: getDay(13), isSelected: false, dayName: getDayName(getDay(13).weekday)),
  MovieChooseDateVO(dateTime: getDay(14), isSelected: false, dayName: getDayName(getDay(14).weekday)),
];

DateTime getDay(int dayDuration) {
  return now.add(Duration(days: dayDuration));
}

enum WeekDay { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

String getDayName(int weekday) {
  switch (weekday) {
    case 1:
      WeekDay weekDay = WeekDay.MONDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    case 2:
      WeekDay weekDay = WeekDay.TUESDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    case 3:
      WeekDay weekDay = WeekDay.WEDNESDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    case 4:
      WeekDay weekDay = WeekDay.THURSDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    case 5:
      WeekDay weekDay = WeekDay.FRIDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    case 6:
      WeekDay weekDay = WeekDay.SATURDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    case 7:
      WeekDay weekDay = WeekDay.SUNDAY;
      dayName = weekDay.toString().substring(8);
      return dayName;
    default:
      return "";
  }
}