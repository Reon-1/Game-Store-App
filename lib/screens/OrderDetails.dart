import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:ecommerce/Provider/globals.dart' as globals;

class Orderdetails extends StatefulWidget {
  const Orderdetails({Key key, this.orderInfo}) : super(key: key);
  final orderInfo;
  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  bool isLoading = true;
  var orders;

  @override
  Widget build(BuildContext context) {
    final cart = jsonDecode(widget.orderInfo['cart']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ORDER ID : DOKAN" + widget.orderInfo['id'].toString(),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Name : " + widget.orderInfo['name'],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Status : " + widget.orderInfo['status'],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PHONE : " + widget.orderInfo['phone_number'],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "ADDRESS : " + widget.orderInfo['address'],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Products",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Text(
                        "Image",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: 120,
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text("Qty"),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 70,
                      child: Text(
                        "Price",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String productName = "";
                  if (cart[index]['name'].length > 15) {
                    for (var i = 0; i < 15; i++) {
                      productName += cart[index]['name'][i];
                    }
                    productName += "...";
                  } else {
                    productName = cart[index]['name'];
                  }
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            width: 50,
                            imageUrl: "${globals.baseUrl}image/" +
                                cart[index]['image_url1'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              productName,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            cart[index]['quantity'].toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 70,
                            child: Text(
                              cart[index]['total'].toString() + ' \$',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: cart.length,
              ),
            ),
            Center(
              child: Text(
                "Total : ${widget.orderInfo['total']} \$",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
