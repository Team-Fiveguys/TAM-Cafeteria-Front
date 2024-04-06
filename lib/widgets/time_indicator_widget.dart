import 'package:flutter/material.dart';

class TimeIndicator extends StatelessWidget {
  const TimeIndicator({
    super.key,
    this.lunchHour,
    this.breakfastHour,
  });

  final String? lunchHour;
  final String? breakfastHour;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: breakfastHour != null ? '조식' : '중식',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              TextSpan(
                text: breakfastHour != null
                    ? '   $breakfastHour'
                    : '   $lunchHour',
                style: TextStyle(
                  fontSize: 8,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
