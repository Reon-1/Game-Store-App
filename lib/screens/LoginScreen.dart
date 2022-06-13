import 'dart:convert';

import 'package:ecommerce/screens/HomeScreen.dart';
import 'package:ecommerce/screens/SignupScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/Provider/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  bool checkEmail = false;
  bool checkPasword = false;
  String password;
  bool isLoading = false;
  Future login(context) async {
    var res;
    try {
      res = await http.post(
        Uri.parse('${globals.baseUrl}api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );
      var json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        String token = json['token'];
        var storeToken = await prefs.setString('token', token);
        var storeName = await prefs.setString('name', json['name']);
        var storeEmail = await prefs.setString('email', json['email']);
        if (token != null && res.statusCode == 200 && storeToken) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Toast.show("something wrong!",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        }
      } else {
        Toast.show("check internet or invalid info.try again!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      Toast.show("check your internet connection.try again!",
          duration: Toast.lengthShort, gravity: Toast.bottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isLoading);
    ToastContext().init(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade900,
              Colors.pink,
              Colors.pink.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            /// Login & Welcome back
            Container(
              height: 210,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// LOGIN TEXT
                  Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 32.5)),
                  SizedBox(height: 7.5),

                  /// WELCOME
                  Text('Welcome Back',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: 60),

                    /// Text Fields
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 10,
                                offset: Offset(0, 10)),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// EMAIL
                          TextField(
                            onChanged: (value) {
                              if (EmailValidator.validate(value)) {
                                setState(() {
                                  checkEmail = true;
                                });
                              } else {
                                setState(() {
                                  checkEmail = false;
                                });
                              }
                              setState(() {
                                email = value;
                              });
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: 'Email',
                              isCollapsed: false,
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Divider(color: Colors.black54, height: 1),

                          /// PASSWORD
                          TextField(
                            obscureText: true,
                            onChanged: (value) {
                              if (value.length >= 4) {
                                setState(() {
                                  checkPasword = true;
                                });
                              } else {
                                setState(() {
                                  checkPasword = false;
                                });
                              }
                              setState(() {
                                password = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: 'Password',
                              isCollapsed: false,
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),

                    /// LOGIN BUTTON
                    MaterialButton(
                      onPressed: () {
                        if (!checkEmail ||
                            !checkPasword ||
                            email == null ||
                            password == null) {
                          Toast.show("check the fields again",
                              duration: Toast.lengthShort,
                              gravity: Toast.bottom);
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          login(context);
                        }
                      },
                      height: 45,
                      minWidth: 240,
                      child: !isLoading
                          ? Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                      textColor: Colors.white,
                      color: Colors.pink,
                      shape: StadiumBorder(),
                    ),
                    SizedBox(height: 25),

                    /// TEXT
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Create new acount',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 25),

                    SizedBox(height: 50),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
