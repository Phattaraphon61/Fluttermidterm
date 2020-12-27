import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String name;
  String email;
  String id;
  List myList = [];

  void data(ids) async {
    String url = 'http://192.168.1.49:8000/${ids}';
    var response = await http.get(url);
    var tt = jsonDecode(response.body);
    setState(() {
      myList = tt;
    });
  }

  void checktoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    print(token);
    if (token == null) {
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    setState(() {
      email = decodedToken['email'];
      name = decodedToken['name'];
      id = decodedToken['id'];
    });
    data(id);
  }

  void sing_out() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String> _calculation() async {
     if (myList.length == 0) {
      checktoken();
    }
    
    
    if (myList.length != 0) {
      return Future.value("Data download successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget datacard = Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (context, index) {
            return Container(
              height: MediaQuery.of(context).size.width * 0.2,
              child: GestureDetector(
                onTap: () async {
                   final status = await Permission.storage.request();

                if (status.isGranted) {
                  print(myList[index]['image']);
                  final externalDir = await getExternalStorageDirectory();

                  final id = await FlutterDownloader.enqueue(
                    url:
                        "http://192.168.1.49:8000/getimage/${myList[index]['image']}",
                    savedDir: externalDir.path,
                    fileName: "download",
                    showNotification: true,
                    openFileFromNotification: true,
                  );


                } else {
                  print("Permission deined");
                }
                },
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 8,
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            children: [
                             myList[index]['image'].split('.').last == "jpg" ? Image.network("http://192.168.1.49:8000/getimage/${myList[index]['image']}",height: 73,):Text(""),
                             myList[index]['image'].split('.').last == "jpeg" ? Image.network("http://192.168.1.49:8000/getimage/${myList[index]['image']}",height: 73,):Text(""),
                             myList[index]['image'].split('.').last == "png" ? Image.network("http://192.168.1.49:8000/getimage/${myList[index]['image']}",height: 73,):Text(""),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                child: Text(myList[index]['image'].toString()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _calculation(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                title:Text("All Files"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                      myList[0]['image']=='88' ? Text(' ') : datacard,
                    ],
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "https://media.shopat24.com/pdmain/269191_02_Blackpink_In_Your_Area.jpg"),
                          ),
                          Text('ชื่อ : $name'),
                          Text('อีเมล : $email')
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("email");
                            Navigator.of(context).pushNamed("/uploadfile");
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(Icons.upload_file, size: 35),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("Upload",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        // const Divider(
                        //   color: Colors.black,
                        //   thickness: 1,
                        //   indent: 0,
                        //   endIndent: 0,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 3),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       print("Dowloadfiles");
                        //       Navigator.of(context).pushNamed("/downloadfile");
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 10),
                        //           child: Icon(Icons.download_sharp, size: 35),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(10),
                        //           child: Text("Dowloadfiles",
                        //               style: TextStyle(
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.bold)),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: GestureDetector(
                            onTap: () {
                              print("sing out");
                              sing_out();
                              Navigator.of(context).pushNamed("/");
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(Icons.logout, size: 35),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("sing out",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'รอสักครู่',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
