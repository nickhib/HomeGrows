import 'package:flutter/material.dart';
import 'appbar.dart';

class FavPlantsPage extends StatelessWidget {
  const FavPlantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Do something when the settings button is pressed
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('fav plants'),
      ),
    );
  }
}