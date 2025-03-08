// ignore_for_file: use_super_parameters

import 'package:animal_reminder/core/services/notification_service.dart';
import 'package:animal_reminder/data/data_sources/database_helper.dart';
import 'package:animal_reminder/logic/cubit/task_cubit.dart';
import 'package:animal_reminder/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();
  await databaseHelper.initDB();
  tz.initializeTimeZones();
  await NotificationService().requestExactAlarmPermission();
  await NotificationService().initNotifications();

  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskCubit(databaseHelper)..getAllTasks(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Animal Care Reminder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
