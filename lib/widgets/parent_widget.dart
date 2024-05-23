import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tict_test/widgets/child_widget.dart';

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  late DateTime _selectedDate = DateTime.now();

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(_selectedDate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChildWidget(
              showDatePickerCallback: () {
                _showDatePicker(context);
              },
              customTextWidget: Text(
                'Day of Week: $dayOfWeek',
              ),
            ),
            ChildWidget(
              showDatePickerCallback: () {
                _showDatePicker(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
