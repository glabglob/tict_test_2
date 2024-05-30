import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tict_test/blocks/user_data_cubit/user_data_cubit.dart';
import 'package:tict_test/blocks/user_data_cubit/user_data_state.dart';
import 'package:tict_test/widgets/user_child_widget.dart';

class UserParentWidget extends StatelessWidget {
  const UserParentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Data')),
      body: Center(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const CircularProgressIndicator();
            } else if (state is UserLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserChildWidget(
                    firstName: state.user['firstName'],
                    lastName: state.user['lastName'],
                    birthDate: state.user['birthDate'],
                    onDateSelected: (newDate) {
                      context.read<UserCubit>().updateBirthDate(newDate, context);
                    },
                  ),
                  const SizedBox(height: 20),
                  UserChildWidget(
                    birthDate: state.user['birthDate'],
                    onDateSelected: (newDate) {
                      context.read<UserCubit>().updateBirthDate(newDate, context);
                    },
                  ),
                ],
              );
            } else {
              return const Text('Failed to load user data');
            }
          },
        ),
      ),
    );
  }
}
