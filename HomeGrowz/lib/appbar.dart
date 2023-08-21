import 'package:first_project/Fav_plants.dart';
import 'package:flutter/material.dart';
import 'My_plants.dart';
import 'Daily.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final List<Widget> actions;

  MyAppBar({required this.backgroundColor, required this.actions});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  Color _backgroundColor = Colors.white;
  bool _flag = true;
  bool _flag2 = true;

  void _changeBackground() {
    setState(() {
      if (_backgroundColor == Colors.black) {
        _backgroundColor = Colors.white;
      } else {
        _backgroundColor = Colors.black;
      }
    });
  }

  final List<String> menuItems = ['My Plants', 'Fav Plants', 'Daily', 'logout'];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image(
        image: AssetImage('assets/flower.png'),
        width: 100,
        height: 50,
      ),
      actions: <Widget>[
        IconButton(
          icon: IconButton(
            icon: Icon(Icons.sunny, color: Colors.black, size: 30.0),
            tooltip: "press forsunny night",
            onPressed: _changeBackground,
          ),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onSelected: (value) {
            switch (value) {
              case 'My Plants':
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyPlantsPage()),
              );
              break;
              case 'Fav Plants':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavPlantsPage()),
                );
                break;
              case 'Daily':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DailyPlantsPage()),
                );
                break;
              case 'My Plants':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPlantsPage()),
                );
                break;
            }


          },
          itemBuilder: (BuildContext context) {
            return menuItems.map((String item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        ),
        ...widget.actions,
      ],
      backgroundColor: widget.backgroundColor ?? _backgroundColor,
    );
  }
}