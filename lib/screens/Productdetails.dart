import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key key, this.product}) : super(key: key);
  final product;
  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState(product: product);
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final product;
  _ProductDetailsScreenState({this.product});

  @override
  void initState() {
    super.initState();
  }

  bool isCard = false;
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<MainProvider>(context);
    final cart = providerData.cart;
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Description"),
      ),
      body: product != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                      minHeight: 100,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: "${globals.baseUrl}image/" +
                                product['image_url1'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 8,
                          child: Container(
                            child: Text(
                              "${product['price']} \$",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 100,
                        minHeight: 10,
                        maxHeight: 100),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 9, left: 20),
                      child: Text(
                        product['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      product['description'],
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    width: 150,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3, top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isCard) {
                          double price = double.parse(product['price']);
                          providerData.addtTocart({
                            "id": product['id'],
                            "name": product['name'],
                            "image_url1": product['image_url1'],
                            "price": price,
                            "quantity": 1,
                            'total': price
                          });
                        }
                        setState(() {
                          isCard = true;
                        });
                      },
                      child: !isCard
                          ? Row(
                              children: [
                                Text('Add to cart'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.add_shopping_cart)
                              ],
                            )
                          : Text('Added to cart'),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
