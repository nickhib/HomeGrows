import 'package:flutter/material.dart';
import 'main.dart';
import 'image_search.dart';
import 'My_plants.dart';
import 'Daily.dart';

class pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    home: Scaffold(
      body: PageView(
        children: const [
          Function1(),
        MyPlantsPage(),
          DailyPlantsPage(),
          VisualSearchApp(),
        ],
      ),
      ),
    );

    throw UnimplementedError();
  }


}