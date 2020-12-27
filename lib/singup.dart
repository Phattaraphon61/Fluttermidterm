import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Singup extends StatefulWidget {
  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  final _formKey = GlobalKey<FormState>();
  var _password = TextEditingController();
  var _conpassword = TextEditingController();
  bool checkemail;
  bool checkpassword;
  bool checkconpassword;
  String name;
  String email;
  String password;
  String conpassword;

  void singup() async {
    String url = 'http://192.168.1.49:8000/checkemail';
    print(email);
    String json = '{"email": "$email"}';
    var response = await http.post(url, body: json);
    var tt = jsonDecode(response.body);
    print(tt);
    if (tt == "this email has already been used") {
      checkemail = false;
      if (_formKey.currentState.validate()) {}
    }
    if (tt == "success") {
      if (password.length < 8) {
        checkpassword = false;
        if (_formKey.currentState.validate()) {}
      }
      if (password.length >= 8) {
        if (password != conpassword) {
          checkconpassword = false;
          if (_formKey.currentState.validate()) {}
        }
        if (password == conpassword) {
          insertdata();
        }
      }
    }
  }

  void insertdata() async {
    String url = 'http://192.168.1.49:8000/singup';
    print(name);
    print(email);
    print(password);
    String json = '{"name": "$name","email": "$email","password":"$password"}';
    var response = await http.post(url, body: json);
    var uu = jsonDecode(response.body);
    if (uu == "success") {
      Navigator.of(context).pushNamed("/singin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sing up",
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
                    keyboardType: TextInputType.name,
                    style: new TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'ชื่อ',
                      icon: Icon(
                        Icons.supervised_user_circle_sharp,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onChanged: (values) {
                      setState(() {
                        name = values;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกชื่อ';
                      }

                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextFormField(
                    // obscureText: true,
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
                        return 'อีกเมลนี้มีคนใช้แล้ว';
                      }

                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
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
                      setState(() {
                        password = values;
                      });
                      if (_formKey.currentState.validate()) {}
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      if (checkpassword == false) {
                        checkpassword = true;
                        return 'รหัสผ่านอย่างน้อยต้อง 8 ตัว';
                      }

                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextFormField(
                    controller: _conpassword,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    style: new TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'ยืนยันรหัส',
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onChanged: (values) {
                      setState(() {
                        conpassword = values;
                      });

                      if (_formKey.currentState.validate()) {
                        // Process data.

                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      if (checkconpassword == false) {
                        checkconpassword = true;
                        return 'รหัสผ่านไม่ตรงกัน';
                      }

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
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/");
                            },
                            child: Text(
                              'ยกเลิก',
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {}
                            singup();
                          },
                          child: Text(
                            'ยืนยัน',
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
        ));
  }
}
