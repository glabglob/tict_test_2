import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tict_test/blocks/date_picker_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateState(DateTime.now()));

  void setDate(DateTime date) => emit(DateState(date));

  Future<void> showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != state.selectedDate) {
      setDate(picked);
    }
  }
}
