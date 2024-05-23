import 'package:flutter/material.dart';
import 'package:tict_test/widgets/parent_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Date Picker Example'),
        ),
        body: const ParentWidget(),
      ),
    );
  }
}
