import 'package:flutter/material.dart';
import 'appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:async';
import 'package:provider/provider.dart';
import 'cred.dart';
import 'dart:typed_data';
class Myrandom with ChangeNotifier{
  late int _id;
  late Timer _timer;
  int get id => _id;
  
  Myrandom(){
    _id = 1;
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _id = Random().nextInt(3000);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

}




class DailyPlantsPage extends StatelessWidget {
  const DailyPlantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Myrandom(),
    child: Scaffold(
      appBar: MyAppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // may change
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DailyPlantsdata(),
          ),
        ],
      ),
    ),
    );
  }
}

class DailyPlantsdata extends StatefulWidget {
  const DailyPlantsdata({Key? key}) : super(key: key);

  @override
  _DailyPlantsdataState createState() => _DailyPlantsdataState();
}
class _DailyPlantsdataState extends State<DailyPlantsdata> {
  late Future<String> _DailyplantData;//set initial value to fetchdata
  @override
  void initState() {
    super.initState();
    final random = Provider.of<Myrandom>(context, listen: false);
    int id = random.id;
        _DailyplantData = DailyplantData(id);
    random.addListener(_Onchange);
  }
  void _Onchange() {
    setState(() {
      final random = Provider.of<Myrandom>(context, listen: false);
      int id = random.id;
      _DailyplantData = DailyplantData(id);
    });
  }
  Future<String> DailyplantData(int id) async {
    final String apiKey = cred.plant_api;
    final String apiUrl = 'https://perenual.com/api/species/details/$id?key=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);
    final name = data['common_name'];
    //final response = await http.get(Uri.parse('https://perenual.com/api/species/details/223?key=sk-ur48644da2ab7cc62701'));
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final random = Provider.of<Myrandom>(context);
    int id = random.id;
    return ChangeNotifierProvider(
        create: (_) => Myrandom(),
        child:Scaffold(
          body: FutureBuilder<String>(
            future: _DailyplantData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator());
              }
              else if (snapshot.hasError)
              {
                return Center(child: Text('Error ths: ${snapshot.error}'));
              }
              else if (!snapshot.hasData)
              {
                return Center(child: Text('No data found'));
              }
              else
              {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 550.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
    );
      }


  @override
  void dispose() {
    super.dispose();
  }
}