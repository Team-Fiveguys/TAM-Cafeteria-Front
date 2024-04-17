import 'package:flutter/material.dart';

class TimeIndicator extends StatelessWidget {
  const TimeIndicator({
    super.key,
    this.lunchHour,
    this.breakfastHour,
    this.name,
  });

  final String? lunchHour;
  final String? breakfastHour;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          breakfastHour != null ? '조식' : name ?? '중식',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        const SizedBox(width: 4), // 첫 번째와 두 번째 Text 사이의 간격 조절
        Flexible(
          // 두 번째 Text에 Flexible 적용
          child: Text(
            breakfastHour != null ? '$breakfastHour' : '$lunchHour',
            style: TextStyle(
              fontSize: 8,
              color: Theme.of(context).primaryColorLight,
            ),
            overflow: TextOverflow.ellipsis, // 너무 길면 말줄임표로 표시
          ),
        ),
      ],
    );
  }
}
