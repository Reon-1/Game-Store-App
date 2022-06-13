import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'package:ecommerce/Provider/globals.dart' as globals;

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);
  static String id = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String email;
  String name;
  String confPassword;
  String password;

  bool checkname = false;
  bool checkEmail = false;
  bool checkPasword = false;
  bool checkConfPass = false;
  bool isLoading = false;
  Future createAccount(context) async {
    print("Come");
    var res;
    try {
      res = await http.post(
        Uri.parse('${globals.baseUrl}api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password
        }),
      );
      print(res.body);
      if (res.statusCode == 500) {
        Toast.show("Email already exist!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      } else if (res.statusCode == 200) {
        Toast.show("Acount creted successfully!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
        Navigator.pop(context);
      } else {
        Toast.show("Something went wrong!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Toast.show("check your internet connection.try again!",
          duration: Toast.lengthShort, gravity: Toast.bottom);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 32.5)),
                  SizedBox(height: 7.5),

                  /// WELCOME
                  Text('Welcome !!',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
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
                      height: 250,
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
                          /// Name
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: 'Name',
                              isCollapsed: false,
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Divider(color: Colors.black54, height: 1),

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
                          Divider(color: Colors.black54, height: 1),

                          /// conf pass
                          TextField(
                            obscureText: true,
                            onChanged: (value) {
                              if (value.length >= 4) {
                                setState(() {
                                  checkConfPass = true;
                                });
                              } else {
                                setState(() {
                                  checkConfPass = false;
                                });
                              }
                              setState(() {
                                confPassword = value;
                              });
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: 'Confirm password',
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
                        setState(() {
                          isLoading = true;
                        });
                        if (!checkEmail ||
                            !checkPasword ||
                            email == null ||
                            password == null ||
                            name == null ||
                            confPassword == null ||
                            password != confPassword) {
                          print("pressed! else");
                          Toast.show("check the fields again",
                              duration: Toast.lengthShort,
                              gravity: Toast.bottom);
                        } else {
                          print("pressed! else");

                          // submit the form
                          createAccount(context);
                        }
                      },
                      height: 45,
                      minWidth: 240,
                      child: !isLoading
                          ? Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                      textColor: Colors.white,
                      color: Colors.pink.shade700,
                      shape: StadiumBorder(),
                    ),
                    SizedBox(height: 25),

                    /// TEXT
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Already have a account?',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 25),
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
