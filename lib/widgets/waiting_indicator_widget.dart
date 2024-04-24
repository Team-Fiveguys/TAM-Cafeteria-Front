import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class WaitingIndicator extends StatefulWidget {
  const WaitingIndicator({
    super.key,
    required this.imageUrl,
    required this.waitingStatus,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  final String imageUrl;
  final String waitingStatus;
  final String currentStatus;
  final Function(String) onStatusChanged;

  @override
  State<WaitingIndicator> createState() => _WaitingIndicatorState();
}

class _WaitingIndicatorState extends State<WaitingIndicator> {
  void setWaitingStatus() async {
    print(
        'WaitingIndicator : setWaitingStatus : waitingStatus ${widget.waitingStatus}');
    await ApiService.postCongestionStatus(
        widget.waitingStatus, 1); // TODO : cafeteriaId 수정하기
    widget.onStatusChanged(widget.waitingStatus);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEqual = widget.currentStatus == widget.waitingStatus;
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
          onPressed: setWaitingStatus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 60,
                height: 40,
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              AutoSizeText(
                widget.waitingStatus,
                style: const TextStyle(
                  color: Color(0xFF6D6D6D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 10,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
