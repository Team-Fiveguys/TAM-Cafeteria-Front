import 'package:flutter/material.dart';

class WriteAnnounceScreen extends StatefulWidget {
  const WriteAnnounceScreen({Key? key}) : super(key: key);

  @override
  State<WriteAnnounceScreen> createState() => _WriteAnnounceScreenState();
}

class _WriteAnnounceScreenState extends State<WriteAnnounceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
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
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                width: 900,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(41),
                  color: const Color(0xff002967),
                ),
                child: const Text(
                  '공지사항 글쓰기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2.0,
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '공지 제목을 작성해주세요',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '글쓰기',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: const Color(0xff002967),
          height: 80,
          child: TextButton(
            onPressed: () {
              // Add your posting logic here
            },
            child: const Text(
              '게시하기',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
