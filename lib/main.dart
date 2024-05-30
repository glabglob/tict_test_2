import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tict_test/blocks/user_data_cubit/user_data_cubit.dart';
import 'package:tict_test/widgets/user_parent_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userCubit = UserCubit();
  await userCubit.loadCachedUser();
  runApp(MyApp(userCubit: userCubit));
}

class MyApp extends StatelessWidget {
  final UserCubit userCubit;
  const MyApp({
    super.key,
    required this.userCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data App',
      home: Scaffold(
        body: BlocProvider(
          create: (_) => userCubit,
          child: const UserParentWidget(),
        ),
      ),
    );
  }
}
