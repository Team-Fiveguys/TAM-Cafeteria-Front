// import 'package:flutter/material.dart';

// class ViewMenuSuggestion extends StatefulWidget {
//   final List<String> titles;
//   final List<String> contents;
//   int currentIndex;

//   ViewMenuSuggestion({
//     Key? key,
//     required this.titles,
//     required this.contents,
//     required this.currentIndex,
//   }) : super(key: key);

//   @override
//   State<ViewMenuSuggestion> createState() => _ViewMenuSuggestionState();
// }

// class _ViewMenuSuggestionState extends State<ViewMenuSuggestion> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: SizedBox(
//                 height: 50,
//                 child: Image.asset(
//                   'assets/images/app_bar_logo.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               alignment: Alignment.center,
//               height: 56,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(41),
//                 color: const Color(0xff002967),
//               ),
//               child: const Text(
//                 '메뉴 건의 보기',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(19),
//                 border: Border.all(
//                   color: Colors.white,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.4),
//                     spreadRadius: 2.0,
//                     blurRadius: 1.0,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(19),
//                             border: Border.all(
//                               color: Colors.white,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.9),
//                                 spreadRadius: 2.0,
//                                 blurRadius: 1.0,
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             widget.titles[widget.currentIndex],
//                             style: const TextStyle(
//                               fontSize: 24.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(19),
//                             border: Border.all(
//                               color: Colors.white,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.9),
//                                 spreadRadius: 2.0,
//                                 blurRadius: 1.0,
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             widget.contents[widget.currentIndex],
//                             style: const TextStyle(fontSize: 18.0),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     if (widget.currentIndex > 0) {
//                       setState(() {
//                         widget.currentIndex--;
//                       });
//                     }
//                   },
//                   child: const Text('이전 메뉴 건의'),
//                 ),
//                 const SizedBox(width: 20.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (widget.currentIndex < widget.titles.length - 1) {
//                       setState(() {
//                         widget.currentIndex++;
//                       });
//                     }
//                   },
//                   child: const Text('다음 메뉴 건의'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
