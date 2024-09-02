class Diet {
  final List<String> names;
  final List<int> ids;
  final String? imageUrl;
  final bool dayOff;
  final bool soldOut;
  final String? meals;

  Diet({
    required this.names,
    required this.ids,
    required this.dayOff,
    required this.soldOut,
    this.imageUrl,
    this.meals,
  });
}
