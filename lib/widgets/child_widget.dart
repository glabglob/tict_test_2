import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChildWidget extends StatelessWidget {
  const ChildWidget({
    required this.showDatePickerCallback,
    this.customTextWidget,
    required this.selectedDate,
    super.key,
  });

  final VoidCallback showDatePickerCallback;
  final Widget? customTextWidget;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Center(
      child: Column(
        children: [
          const Text('Child Widget'),
          if (customTextWidget != null) customTextWidget!,
          Text('Selected Date: $formattedDate'),
          ElevatedButton(
            onPressed: showDatePickerCallback,
            child: const Text('Select Date'),
          ),
        ],
      ),
    );
  }
}
