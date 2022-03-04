class MovieChooseDateVO {
  DateTime dateTime;
  String dayName;
  bool isSelected;

  MovieChooseDateVO({required this.dateTime, required this.isSelected, required this.dayName});

  @override
  String toString() {
    return 'MovieChooseDateVO{dateTime: $dateTime, dayName: $dayName, isSelected: $isSelected}';
  }
}
