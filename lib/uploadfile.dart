import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Uploadfile extends StatefulWidget {
  @override
  _UploadfileState createState() => _UploadfileState();
}

class _UploadfileState extends State<Uploadfile> {
  List<File> files;
  File file;
  String name;
  String email;
  String id;
  String text = '';

  void printdd() {
    // for (var i in file) {
    //   String fileName = i.path.split('.').last;
    //   print("Name : $fileName");
    // }
    String fileName = file.path.split('.').last;
    print("Name : $fileName");
  }

  void upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();
    // string to uri
    var uri = Uri.parse("http://192.168.1.49:8000/files/$id/");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();
    print(response.statusCode);

    print(response.contentLength);

    response.stream.transform(utf8.decoder).listen((value) {
      print("HHHH$value");
    });
  }

  void getHttp() async {
    try {
      Response response = await Dio().put("http://192.168.1.49:8000");
      print(response);
    } catch (e) {
      print(e);
    }
  }
    void initState() {
    checktoken();
  }

  void checktoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token == null) {}

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    setState(() {
      email = decodedToken['email'];
      name = decodedToken['name'];
      id = decodedToken['id'];
    });
  }

  void sing_out() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void allupload() {
    for (var i in files) {
      upload(i);
    }

    setState(() {
      text = "เรียบร้อยแล้ว";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
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
                    print("homepage");
                    Navigator.of(context).pushNamed("/homepage");
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.home, size: 35),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("home",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
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
                //                   fontSize: 18, fontWeight: FontWeight.bold)),
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
                                  fontSize: 18, fontWeight: FontWeight.bold)),
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
      body: Center(
             child:Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.only(top:250),
                   child: Text(text),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top:10),
                   child: SizedBox(
                     height: 50,
                     width: 100,
                     child: ElevatedButton(
        onPressed: () async {
          // getHttp();
          // var file = await ImagePicker.pickImage(source: ImageSource.gallery);
          // file = await FilePicker.getFile();
          // upload(file);
          // var res = upload(files);
          // printdd(files);

          files = await FilePicker.getMultiFile();
          allupload();
          // print(files);
          // printdd();
        },
        child: Icon(Icons.upload_file,size: 30,),
      ),
                   ),
                 ),
               ],
             ),
      ),
    );
  }
}
