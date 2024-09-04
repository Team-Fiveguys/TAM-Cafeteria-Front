class Diet {
  final List<String> names;
  final String? imageUrl;
  final bool dayOff;
  final bool soldOut;
  final String? meals;
  final String? date;

  Diet({
    required this.names,
    required this.dayOff,
    required this.soldOut,
    this.imageUrl,
    this.meals,
    this.date,
  });
}
