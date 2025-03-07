import 'package:animal_reminder/core/services/notification_service.dart';
import 'package:animal_reminder/logic/cubit/todo_cubit.dart';
import 'package:animal_reminder/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().createNotificationChannel();
  await NotificationService().requestNotificationPermissions();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoCubit()..loadTodos(),

        child: HomePage(),
      ),
    );
  }
}
