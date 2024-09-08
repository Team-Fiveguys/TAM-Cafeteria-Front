import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MultiSelectCalendarWidget extends StatefulWidget {
  const MultiSelectCalendarWidget({super.key});

  @override
  _MultiSelectCalendarWidgetState createState() =>
      _MultiSelectCalendarWidgetState();
}

class _MultiSelectCalendarWidgetState extends State<MultiSelectCalendarWidget> {
  late final ValueNotifier<List<DateTime>> _selectedDays;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDays = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedDays.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.value.any((day) => isSameDay(selectedDay, day))) {
        _selectedDays.value = _selectedDays.value
            .where((day) => !isSameDay(selectedDay, day))
            .toList();
      } else {
        _selectedDays.value = [..._selectedDays.value, selectedDay];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => _selectedDays.value
              .any((selectedDay) => isSameDay(selectedDay, day)),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call setState() here
          },
        ),
        ElevatedButton(
          onPressed: () {
            // 여기서 _selectedDays.value로 선택된 날짜들을 사용할 수 있습니다.
          },
          child: const Text('선택된 날짜 출력'),
        ),
      ],
    );
  }
}
