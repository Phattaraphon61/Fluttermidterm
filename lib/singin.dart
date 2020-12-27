import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Singin extends StatefulWidget {
  @override
  _SinginState createState() => _SinginState();
}

class _SinginState extends State<Singin> {
  final _formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  String email;
  String password;
  bool checkemail;
  bool checkpass;

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
  }

  void singin() async {
    String url = 'http://192.168.1.49:8000/singin';

    String json = '{"email": "$email", "password": "$password"}';
    var response = await http.post(url, body: json);
    var tt = jsonDecode(response.body);
    if (tt['status'] == "singin success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', tt['token']);
      checktoken();
    }
    if (tt['status'] == "invalid email") {
      checkemail = false;
      if (_formKey.currentState.validate()) {}
    }
    if (tt['status'] == "password is incorrect") {
      checkpass = false;
      if (_formKey.currentState.validate()) {}
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Singin",
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    icon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (values) {
                    setState(() {
                      email = values;
                    });

                    if (_formKey.currentState.validate()) {
                      // Process data.

                    }
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกอีเมล';
                    }

                    if (checkemail == false) {
                      checkemail = true;
                      return 'อีกเมลไม่ถูกต้อง';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  controller: _controller,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    icon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (values) {
                    // setState(() {
                    //   password = values;
                    // });

                    if (_formKey.currentState.validate()) {
                      // Process data.

                    }
                  },
                  validator: (value) {
                    if (checkpass == false) {
                      checkpass = true;
                      return 'รหัสผ่านไม่ถูกต้อง';
                    }
                    if (value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    setState(() {
                      password = value;
                    });
                    return null;
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 129,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 20,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed("/singup");
                          },
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 129,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          onPrimary: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 20,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {}
                          singin();
                        },
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
