import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart' as img;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'appbar.dart';
import 'cred.dart';


class VisualSearchApp extends StatefulWidget {
  const VisualSearchApp({Key? key});

  @override
  _VisualSearchAppState createState() => _VisualSearchAppState();
}
bool snap = false;
class _VisualSearchAppState extends State<VisualSearchApp> {
  Future<Map<String, dynamic>>? _SearchResults;
  img.XFile? pickedImage;
  late Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBar(
          backgroundColor: Colors.lightGreen,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  pickedImage = await img.ImagePicker().pickImage(source: img.ImageSource.camera);
                  if(pickedImage != null){
                    imageData = await pickedImage!.readAsBytes();
                    setState(() {//update state of widget
                      _SearchResults = getSearchResults(imageData);//passes the image
                      snap = true;
                    });
                  }
                  //ByteData bytes = await rootBundle.load('assets/flower.png');//loads data as bytedata
                  //Uint8List imageData = bytes.buffer.asUint8List();//image data contains the byte data of image
                  //print('Image length: ${imageData.length}');
                },
                child: Text('Search'),
              ),
              SizedBox(height: 20),
        FutureBuilder<Map<String, dynamic>>(//furture builder is good for api use
          future: _SearchResults,
          builder: (context, snapshot) {//snapshot is checking the state of furture
            if (snapshot.hasData)
            {
              return Text(json.encode(snapshot.data));//will return what was found in api
            }
            else if (snapshot.hasError)
            {
              return Text('Error: ${snapshot.error}');
            }
            else//if their is no data from furture this will continue to spin
            {
              if(snap == true) {
                snap = false;
                return const CircularProgressIndicator();
              }
                return const SizedBox(
                  height: 0,
                  width: 0,
                );

            }
          },
        ),
        ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getSearchResults(Uint8List imageData) async {//first input my credentials for authentication
  final creds = cred.google_vision;
  final scopes = [vision.VisionApi.cloudVisionScope];//need to do this for api
  final client = await clientViaServiceAccount(creds, scopes);//add cred and scope
  final visionApi = vision.VisionApi(client);
  final image = vision.Image();//image is provided by googleapis it represents a
  //image that can be used by visual api
  image.content = base64.encode(imageData);
  final feature = vision.Feature()
    ..type = 'WEB_DETECTION';
  final request = vision.AnnotateImageRequest()
    ..image = image
    ..features = [feature];
  final myrequest = vision.BatchAnnotateImagesRequest()
    ..requests = [request];
  final response = await visionApi.images.annotate(myrequest);

  final getdiscription = response.responses?.first.webDetection;
  final webEntities = getdiscription?.webEntities
      ?.map((entity) => {'description': entity.description, 'score': entity.score})
      .toList();
  final bestGuessLabels = getdiscription?.bestGuessLabels
      ?.map((label) => label.label)
      .toList();

  return {
    'webEntities': webEntities,
    'bestGuessLabels': bestGuessLabels,
  };
}
