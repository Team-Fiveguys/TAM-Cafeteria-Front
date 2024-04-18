class Diets {
  final int? id;
  final String dayOfWeek;
  final String photoUrl;
  final Map<String, dynamic> menu;

  Diets.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dayOfWeek = json["dayOfWeek"],
        photoUrl = json["photoURI"],
        menu = json["menuResponseListDTO"];
}
