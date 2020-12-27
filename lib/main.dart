import 'package:downloadteach/UploadFiles.dart';
import 'package:downloadteach/singin.dart';
import 'package:downloadteach/singup.dart';
import 'package:downloadteach/uploadfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Homepage.dart';
import 'downloadfile.dart';
const debug = true;
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
      runApp( new MaterialApp(
        home: new MyApp(),
        routes: <String, WidgetBuilder>{
          //  "/" : (BuildContext context)=> new MyApp(),
         "/homepage" : (BuildContext context)=> new Homepage(),
          "/singin" : (BuildContext context)=> new Singin(),
          "/singup" : (BuildContext context)=> new Singup(),
          "/uploadfile" : (BuildContext context)=> new Uploadfile(),
          "/downloadfile" : (BuildContext context)=> new Downloadfile(),
          //add more routes here
        },

      ));
    }
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   void initState() {
    checktoken();
  }

  void checktoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      Navigator.of(context).pushNamed("/homepage");
        // Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => SecondRoute()));
    }
    else{
      Navigator.of(context).pushNamed("/singin");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}