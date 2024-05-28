import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/pages/home/binding.dart';
import 'package:flutter_application_2/app/pages/home/view.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/home",
      getPages: [
        GetPage(name: "/home", page: () => HomeView(), binding: HomeBinding())
      ],
    );
  }
}
