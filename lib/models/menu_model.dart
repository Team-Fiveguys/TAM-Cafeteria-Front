class MenuList {
  final List<Map<String, dynamic>> menuList;

  MenuList.fromJson(Map<String, dynamic> json)
      : menuList = json["menuQueryDTOList"];
}

class Menu {
  final String name;

  Menu.fromJson(Map<String, dynamic> json) : name = json["name"];
}
