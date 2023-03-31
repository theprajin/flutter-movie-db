import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/adapters.dart';

import 'package:movies_db/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 500));

  await Hive.initFlutter();

  await Hive.openBox<String>('movie');

  runApp(
    const ProviderScope(
      child: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}


