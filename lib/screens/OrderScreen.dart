import 'dart:convert';

import 'package:ecommerce/screens/OrderDetails.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    getOrder();
    super.initState();
  }

  bool isLoading = true;
  var orders;
  Future getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String bearerToken = "Bearer $token";
    try {
      final res =
          await http.get(Uri.parse('${globals.baseUrl}api/order'), headers: {
        'Authorization': bearerToken,
      });

      if (res.statusCode == 200) {
        // print cart product name
        // print(jsonDecode(jsonDecode(res.body)[0]['cart'])[0]['name']);
        setState(() {
          orders = jsonDecode(res.body);
        });

        setState(() {
          isLoading = false;
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: !isLoading
          ? Container(
              child: ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // navigate to order details page
                    print('tapped!!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Orderdetails(
                          orderInfo: orders[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text("DOKAN" + orders[index]['id'].toString()),
                          Spacer(),
                          Text(orders[index]['status'])
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: orders.length,
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
