import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WaitingIndicator extends StatelessWidget {
  const WaitingIndicator({
    super.key,
    required this.imageUrl,
    required this.waitingStatus,
    required this.currentStatus,
  });

  final String imageUrl;
  final String waitingStatus;
  final String currentStatus;

  @override
  Widget build(BuildContext context) {
    final bool isEqual = currentStatus == waitingStatus;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(
            width: isEqual ? 3 : 1,
            color:
                isEqual ? Theme.of(context).cardColor : const Color(0xFF999999),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 60,
                height: 40,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              AutoSizeText(
                waitingStatus,
                style: const TextStyle(
                  color: Color(0xFF6D6D6D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 10,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
