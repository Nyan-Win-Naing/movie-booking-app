class MovieChooseDateVO {
  DateTime dateTime;
  String dayName;
  bool isSelected;

  MovieChooseDateVO({required this.dateTime, required this.isSelected, required this.dayName});

  @override
  String toString() {
    return 'MovieChooseDateVO{dateTime: $dateTime, dayName: $dayName, isSelected: $isSelected}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieChooseDateVO &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          dayName == other.dayName &&
          isSelected == other.isSelected;

  @override
  int get hashCode =>
      dateTime.hashCode ^ dayName.hashCode ^ isSelected.hashCode;
}
