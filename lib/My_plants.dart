import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/keep/v1.dart';
import 'appbar.dart';
import 'package:image_picker/image_picker.dart';
///referenced https://www.youtube.com/watch?v=odg--WqWOSM&ab_channel=TechSpartans for the list view design
///tried to add more
class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListPage(),
      debugShowCheckedModeBanner: false,
      );
  }
}
  class ListPage extends StatefulWidget {
    _ListPageState createState() => _ListPageState();
  }
class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> names = [//will take image url and name will take picture soon
  ];
  void _addItem() async {
    final result = await showDialog<Map<String, dynamic>>(//should wait till done
      context: context,
      builder: (BuildContext context) {
        String? plant_name = "";//title = ""
        Uint8List? pictureurl;
        return AlertDialog(//will make a pop up add menu kinda
          title: Text("Add Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,// will shrink wrap its children to fit within its width if understand it right
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "plant_name",
                ),
                onChanged: (value) {//gets updated value of plant_namn
                  plant_name = value;
                },
              ),
              ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                 final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                if(photo != null){
                    final Uint8List bytes = await photo.readAsBytes();
                    pictureurl = bytes;
                }
                else
                {
                  if(kDebugMode){
                    print('no photo captured');
                  }
                }

                  }, child: Text("Select Image"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close current screen
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({// close current screen
                  "plant_name": plant_name,
                  "picture_url": pictureurl,
                }); // return  the end result this will be added to the list
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        names.add(result);//finally adds to the map setstate with change the state
      });
    }
  }
  void _edititem(Map<String, dynamic> item, int index) async {
    final result = await showDialog<Map<String, dynamic>>(//should wait till done
      context: context,
      builder: (BuildContext context) {
        String plant_name = item['plant_name'] ?? '';//title = ""
        Uint8List? pictureurl = item['picture_url'];
        return AlertDialog(//will make a pop up add menu kinda
          title: Text("Add Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,// will shrink wrap its children to fit within its width if understand it right
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "plant_name",
                ),
                onChanged: (value) {//gets updated value of plant_namn
                  plant_name = value;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                  if(photo != null){
                    final Uint8List bytes = await photo.readAsBytes();
                    pictureurl = bytes;
                  }
                  else
                  {
                    if(kDebugMode){
                      print('no photo captured');
                    }
                  }

                }, child: Text("Select Image"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close current screen
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({// close current screen
                  "plant_name": plant_name,
                  "picture_url": pictureurl,
                }); // return  the end result this will be added to the list
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        names[index] = result;//finally adds to the map setstate with change the state
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Do something when the settings button is pressed
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: names.length,
        shrinkWrap: true,

        itemBuilder: (BuildContext context, int index) =>GestureDetector(
          onTap: (){

          },
          onLongPress: () {
            _edititem(names[index],  index);
          },
            child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55.0,
                        height: 55.0,
                        color: Colors.green,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.green,
                          backgroundImage: names[index]['picture_url'] != null
                              ? MemoryImage(names[index]['picture_url'] ) as ImageProvider<Object>? // cast object as type
                              : AssetImage('assets/flower.png'),//default image
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            names[index]['plant_name']!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            ),

          ),

        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,//onpressed with then call additem
        child: Icon(Icons.add),
      ),

    );
  }
}

