import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';
//전체 페이지에 대한 user 검색
//페이지 수 제한?

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({Key? key}) : super(key: key);

  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  late Future<List<User>> _userList;
  int _currentPage = 1; // 현재 페이지 번호
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userList = _fetchUserList(_currentPage); // Fetch initial user list.
  }

  Future<List<User>> _fetchUserList(int page) async {
    // Fetch users for the given page.
    return await ApiService.getUsers(page);
  }

  void _revokeRole(int userId) async {
    try {
      await ApiService.revokeAdminRole(userId);
      _refreshUserList(); // Refresh user list after revoking admin role.
    } catch (e) {
      // Error handling
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void _grantAdminRoleAndUpdateList(int userId) async {
    try {
      // Grant admin role to the user.
      await ApiService.grantAdminRole(userId);
      _refreshUserList(); // Refresh user list after granting admin role.
    } catch (e) {
      // Error handling
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void _refreshUserList() {
    setState(() {
      _userList = _fetchUserList(_currentPage); // Fetch and refresh user list.
    });
  }

  List<User> _filterUserList(List<User> userList, String query) {
    return userList.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _goToNextPage() {
    setState(() {
      _currentPage++; // Move to the next page.
      _refreshUserList(); // Fetch and refresh user list for the new page.
    });
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--; // Move to the previous page.
        _refreshUserList(); // Fetch and refresh user list for the new page.
      });
    }
  }

  void showCafeteriaListDialog(BuildContext context) async {
    // Cafe List를 가져오는 비동기 함수를 호출
    final List<Cafeteria> cafeteriaList = await ApiService.getCafeteriaList();

    // 다이얼로그를 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('식당 목록'),
          content: SingleChildScrollView(
            child: Column(
              children: cafeteriaList.map((cafeteria) {
                return ListTile(
                  title: Text(cafeteria.name),
                  // 추가적인 식당 정보를 표시하고 싶다면 이 부분에 추가
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: Image.asset(
            'assets/images/app_bar_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼을 비활성화
                leading: IconButton(
                  // leading 위치에 아이콘 버튼 배치
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  '유저관리페이지',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true, // title을 중앙에 배치
              ),
            ),
          ),
          TextField(
            controller: _searchController,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            onChanged: (value) {
              _refreshUserList();
            },
            decoration: const InputDecoration(
              labelText: '검색',
              hintText: '아이디로 검색',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _userList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load data.'));
                } else if (snapshot.hasData) {
                  final filteredUsers =
                      _filterUserList(snapshot.data!, _searchController.text);
                  return ListView.separated(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 16.0),
                        title: Row(
                          children: [
                            Text(user.name.isEmpty ? "SNS USER" : user.name,
                                style: const TextStyle(fontSize: 20.0)),
                            const SizedBox(width: 8.0), // 간격 조정
                            Text('(${user.role})',
                                style: const TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        subtitle: Text(
                            user.email.isEmpty ? "APPLE USER" : user.email,
                            style: const TextStyle(fontSize: 16.0)),
                        trailing: user.role == 'MEMBER'
                            ? ElevatedButton(
                                onPressed: () =>
                                    _grantAdminRoleAndUpdateList(user.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text('부여',
                                    style: TextStyle(color: Colors.white)),
                              )
                            : user.role == 'ADMIN'
                                ? ElevatedButton(
                                    onPressed: () => _revokeRole(user.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text('회수',
                                        style: TextStyle(color: Colors.white)),
                                  )
                                : null,
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  );
                } else {
                  return const Center(
                      child: Text('No user information available.'));
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goToPreviousPage,
              ),
              for (int i = _currentPage; i <= _currentPage + 4; i++)
                if (i <= 15) // Adjust the upper limit as needed
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPage = i;
                        _refreshUserList();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '$i',
                        style: TextStyle(
                          color: _currentPage == i ? Colors.blue : Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _goToNextPage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
