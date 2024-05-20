import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/announcement_board_screen.dart';
import 'package:tam_cafeteria_front/screens/menu_suggestion_board_screen.dart';

class EnterBoardScreen extends StatelessWidget {
  const EnterBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
      crossAxisAlignment: CrossAxisAlignment.start, // Align buttons to the left
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0), // Add left padding
          child: Container(
            width: double.infinity, // Match parent width
            height: 60, // Set desired height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Black border
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MenuBoardScreen()),
                );
              },
              child: const Text('메뉴 건의 게시판'),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0), // Add left padding
          child: Container(
            width: double.infinity, // Match parent width
            height: 60, // Set desired height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Black border
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnnounceBoardScreen()),
                );
              },
              child: const Text('공지게시판'),
            ),
          ),
        ),
      ],
    );
  }
}
