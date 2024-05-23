import 'package:flutter/material.dart';

class ChildWidget extends StatelessWidget {
  const ChildWidget({
    required this.showDatePickerCallback,
    this.customTextWidget,
    super.key,
  });

  final VoidCallback showDatePickerCallback;
  final Widget? customTextWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Child Widget'),
          if (customTextWidget != null) customTextWidget!,
          ElevatedButton(
            onPressed: showDatePickerCallback,
            child: const Text('Select Date'),
          ),
        ],
      ),
    );
  }
}
