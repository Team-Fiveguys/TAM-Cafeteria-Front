class Menu {
  final List<dynamic> menuList;

  Menu.fromJson(Map<String, dynamic> json)
      : menuList = json["menuQueryDTOList"];
}
