import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserChildWidget extends StatelessWidget {
  const UserChildWidget({
    this.firstName,
    this.lastName,
    required this.birthDate,
    required this.onDateSelected,
    super.key,
  });

  final String? firstName;
  final String? lastName;
  final String birthDate;
  final void Function(String) onDateSelected;

  // Метод для форматирования даты
  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(parsedDate);
    } catch (e) {
      return date; // Возвращаем оригинальную строку, если парсинг не удался
    }
  }

  @override
  Widget build(BuildContext context) {
    // Форматируем дату для отображения
    String formattedBirthDate = _formatDate(birthDate);

    return Column(
      children: [
        if (firstName != null && lastName != null)
          Text('Name: $firstName $lastName'),
        Text('Birth Date: $formattedBirthDate'),
        ElevatedButton(
          onPressed: () async {
            DateTime initialDate;

            try {
              initialDate = DateTime.parse(birthDate);
            } catch (e) {
              initialDate = DateTime.now();
            }

            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              final newDate = picked.toIso8601String();
              print('New Date: $newDate');
              onDateSelected(newDate);
            }
          },
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}