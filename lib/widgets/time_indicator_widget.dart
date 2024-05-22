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
    // String? myeongBunLunch;
    // String? myeongBunDinner;
    // if (name == "명돈이네") {
    //   myeongBunLunch = lunchHour!.split("|")[0];
    //   myeongBunDinner = lunchHour!.split("|")[1];
    // }
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
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 4), // 첫 번째와 두 번째 Text 사이의 간격 조절
        Flexible(
          // 두 번째 Text에 Flexible 적용
          child: Column(
            children: [
              Text(
                breakfastHour != null ? '$breakfastHour' : '$lunchHour',
                style: TextStyle(
                  fontSize: 8,
                  color: Theme.of(context).primaryColorLight,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              // if (name == "명돈이네")
              //   Text(
              //     myeongBunDinner!,
              //     style: TextStyle(
              //       fontSize: 8,
              //       color: Theme.of(context).primaryColorLight,
              //     ),
              //     overflow: TextOverflow.ellipsis,
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}
