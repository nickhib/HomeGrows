import 'package:first_project/pages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'appbar.dart';

class Function1 extends StatefulWidget {
  const Function1({Key? key}) : super(key: key);

  @override
  _Function1State createState() => _Function1State();
}
class _Function1State extends State<Function1> {
  Color _backgroundColor = Colors.white;
  bool _flag = true;
  bool _flag2 = true;
  void _changeBackground() {
    setState(() {
      if (_backgroundColor == Colors.black) {
        _backgroundColor = Colors.white;
      }
      else {
        _backgroundColor = Colors.black;
      }
    });
  }
  final List<String> menuItems = ['My Plants', 'Fav Plants', 'Daily' , 'logout'];
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
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
        body: Container(
            color: Colors.lightGreen[100],
          child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome to",
                  style: TextStyle(fontSize: 34),
                    ),
                      Text("HomeGrowz",
                        style: TextStyle(fontSize: 34),
                      ),
                      Text("swipe to the right for content",
                        style: TextStyle(fontSize: 14),
                      ),
                  ]),
                ))));
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(pages());
}