import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tict_test/blocks/date_picker_cubit.dart';
import 'package:tict_test/blocks/date_picker_state.dart';
import 'package:tict_test/widgets/child_widget.dart';

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateState>(
      builder: (context, state) {
        String dayOfWeek = DateFormat('EEEE').format(state.selectedDate);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChildWidget(
                  showDatePickerCallback: () {
                    context.read<DateCubit>().showDatePickerDialog(context);
                  },
                  customTextWidget: Text(
                    'Day of Week: $dayOfWeek',
                  ),
                  selectedDate: state.selectedDate,
                ),
                ChildWidget(
                  showDatePickerCallback: () {
                    context.read<DateCubit>().showDatePickerDialog(context);
                  },
                  selectedDate: state.selectedDate,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
