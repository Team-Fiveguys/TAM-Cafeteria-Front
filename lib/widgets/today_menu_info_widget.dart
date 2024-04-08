import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/widgets/time_indicator_widget.dart';

class TodayMenuInfo extends StatelessWidget {
  const TodayMenuInfo({
    super.key,
    required this.cafeteriaName,
    required this.lunchHour,
    this.breakfastHour,
  });

  final String cafeteriaName;
  final String lunchHour;
  final String? breakfastHour;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 5),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cafeteriaName,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {}, //메뉴 사진 팝업 함수 필요
                  child: Row(
                    children: [
                      Text(
                        '메뉴 사진 보기',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 8),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      TimeIndicator(
                        lunchHour: lunchHour,
                        breakfastHour: breakfastHour,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      breakfastHour != null
                          ? TimeIndicator(
                              lunchHour: lunchHour,
                            )
                          : RichText(text: const TextSpan()),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      RichText(text: const TextSpan()),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
