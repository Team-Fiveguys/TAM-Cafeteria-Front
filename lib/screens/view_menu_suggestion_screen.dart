import 'package:flutter/material.dart';

class ViewMenuSuggestionScreen extends StatefulWidget {
  final String title;
  final String content;

  const ViewMenuSuggestionScreen({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<ViewMenuSuggestionScreen> createState() =>
      _ViewMenuSuggestionScreenState();
}

class _ViewMenuSuggestionScreenState extends State<ViewMenuSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/app_bar_logo.png',
          fit: BoxFit.contain,
          height: 50, // SizedBox를 제거하고 직접 높이를 지정합니다.
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(41),
                color: const Color(0xff002967),
              ),
              child: const Text(
                '게시물 보기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 2.0,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 400,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 2.0,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              widget.content,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
