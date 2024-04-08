class Cafeteria {
  final String name, lunchHour;
  final String? breakfastHour;

  Cafeteria.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        breakfastHour = json['breakfast_hour'],
        lunchHour = json['lunch_hour'];
}
