import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({Key? key}) : super(key: key);

  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  late Future<List<User>> _userList;
  int _currentPage = 1; // 현재 페이지 번호

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
      print("Failed to revoke admin role: $e");
    }
  }

  void _grantAdminRoleAndUpdateList(int userId) async {
    try {
      // Grant admin role to the user.
      await ApiService.grantAdminRole(userId);
      _refreshUserList(); // Refresh user list after granting admin role.
    } catch (e) {
      // Error handling
      print("Failed to grant admin role: $e");
    }
  }

  void _refreshUserList() {
    setState(() {
      _userList = _fetchUserList(_currentPage); // Fetch and refresh user list.
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              // Expanded로 Row의 자식을 감싸서 중앙 정렬 유지
              child: SizedBox(
                height: 50,
                child: Image.asset(
                  'assets/images/app_bar_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        leading: Container(),
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
                    // if(initMenuListLength) TODO: 추가한 메뉴가 있을때 확인알림 해줘야할듯?
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
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _userList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load data.'));
                } else if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 16.0),
                        title: Text(user.name,
                            style: const TextStyle(fontSize: 20.0)),
                        subtitle: Text('${user.email} (${user.role})',
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