import 'dart:async';
import 'dart:convert';

import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: PlaceOrder(),
  ));
}

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  _validate() {
    return _form.currentState.validate();
  }

  String name;
  String email;
  String address;
  String trxId;
  String note;
  String phoneNumber;
  bool bkash = false;
  bool nagad = false;
  bool roket = false;
  bool isLoading = false;
  bool cashOnDelivery = false;
  String paymentNumber;
  List<Widget> payment(number) {
    return [
      SizedBox(
        height: 6,
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 1.7),
        child: Text(
          "Payment to : $number",
          style: TextStyle(fontSize: 18),
        ),
      ),
      SizedBox(
        height: 6,
      ),
      TextFormField(
        onChanged: (value) {
          setState(() {
            paymentNumber = value;
          });
        },
        validator: ValidationBuilder().maxLength(50).build(),
        decoration: InputDecoration(
          labelText: 'Payment from',
        ),
      ),
      SizedBox(
        height: 6,
      ),
      TextFormField(
        onChanged: (value) {
          setState(() {
            trxId = value;
          });
        },
        validator: ValidationBuilder().maxLength(50).build(),
        decoration: InputDecoration(
          labelText: 'trx ID',
        ),
      ),
    ];
  }

  Future submitOrder(cart) async {
    print(name);
    // calculate total amount
    double total = 0.0;
    for (var i = 0; i < cart.length; i++) {
      total += cart[i]['price'];
    }
    print(total);

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String bearerToken = "Bearer $token";
    print("comer");
    try {
      print("comer");
      var res = await http.post(
        Uri.parse('${globals.baseUrl}api/order'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          "Authorization": bearerToken
        },
        body: jsonEncode(<String, String>{
          "cart": jsonEncode(cart),
          "note": note,
          "address": address,
          "phone_number": phoneNumber,
          "paymentNumber": paymentNumber,
          "trxId": trxId,
          "total": total.toString(),
          "name": name,
          "email": email,
          "payment_method": "bkash"
        }),
      );
      print(res.body);
      if (res.statusCode == 500) {
        Toast.show("Internal server error!.try again!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      } else if (res.statusCode == 200) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Order Placed Successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        cart = [];
      } else {
        Toast.show("check your internet connection.try again!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      Toast.show("check your internet connection.try again!",
          duration: Toast.lengthShort, gravity: Toast.bottom);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<MainProvider>(context);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Billings Details'),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator:
                    ValidationBuilder().minLength(5).maxLength(50).build(),
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
                validator:
                    ValidationBuilder().minLength(5).maxLength(50).build(),
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                validator:
                    ValidationBuilder().minLength(5).maxLength(50).build(),
                decoration: InputDecoration(
                  labelText: 'Phone number',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    note = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Note',
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 1.7),
                child: Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        bkash = !bkash;
                        nagad = false;
                        roket = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: bkash ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Bkash",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        nagad = !nagad;
                        bkash = false;
                        roket = false;
                        cashOnDelivery = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: nagad ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Nagad",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        roket = !roket;
                        nagad = false;
                        bkash = false;
                        cashOnDelivery = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: roket ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Roket",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        cashOnDelivery = !cashOnDelivery;
                        nagad = false;
                        bkash = false;
                        roket = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            cashOnDelivery ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Cash on Delivery",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              if (bkash) ...payment('01999999999'),
              if (nagad) ...payment('01777777777'),
              if (roket) ...payment('01666666666'),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    submitOrder(providerData.cart);
                  }
                },
                child: !isLoading
                    ? Text(
                        'Place Order',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    : CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
