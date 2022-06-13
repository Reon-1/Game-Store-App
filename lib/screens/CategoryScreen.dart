import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'CartScreen.dart';
import 'Productdetails.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key, this.id, this.categoryName}) : super(key: key);
  final categoryName;
  final id;
  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState(categoryName: categoryName, id: id);
}

class _CategoryScreenState extends State<CategoryScreen> {
  _CategoryScreenState({this.id, this.categoryName});
  final id;
  String categoryName;
  List isCard = [];
  List products = [];
  bool loading = true;
  String message = "";
  Future getProduct() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      print('here is token');
      print(token);
      String bearerToken = "Bearer $token";
      final res = await http.get(
          Uri.parse("${globals.baseUrl}api/categories/$id"),
          headers: {"Authorization": bearerToken});
      final mainData = jsonDecode(res.body);
      setState(() {
        products = mainData;
        isCard = List.filled(products.length, false);
      });
      if (res.statusCode == 200 && mainData.length == 0) {
        setState(() {
          message = "No product Found";
        });
      } else if (res.statusCode == 404) {
        setState(() {
          message = "Category not found!";
        });
      } else if (res.statusCode == 200) {
      } else {
        Toast.show("something went wrong.try again!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      Toast.show("check your internet connection.try again!",
          duration: Toast.lengthShort, gravity: Toast.bottom);
    }
  }

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(products.length);
    ToastContext().init(context);
    final providerData = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName != null ? categoryName.toUpperCase() : ""),
        actions: [
          Container(
              child: Stack(
            children: [
              IconButton(
                padding: EdgeInsets.only(right: 20),
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 3,
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.blueAccent,
                    child: Text(providerData.cart.length.toString()),
                  ),
                ),
              )
            ],
          ))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50),
                itemBuilder: (context, index) {
                  return GridTile(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: products[index],
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: "${globals.baseUrl}image/" +
                            products[index]['image_url1'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      //     Image.network(
                      //   "http://192.168.1.21:8000/image/" +
                      //       products[index]['image_url1'],
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: products[index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index]['name'],
                            ),
                            Text(
                              "${products[index]['price'].toString()} ${new String.fromCharCodes(new Runes('\u0024'))}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            !isCard[index]
                                ? Icons.add_shopping_cart
                                : Icons.done,
                            color: isCard[index] ? Colors.green : Colors.white,
                            size: 35,
                          ),
                          onPressed: () {
                            !isCard[index]
                                ? providerData.addtTocart({
                                    "id": products[index]['id'],
                                    "name": products[index]['name'],
                                    "image_url1": products[index]['image_url1'],
                                    "price": products[index]['price'],
                                    "quantity": 1,
                                    'total': products[index]['price']
                                  })
                                : null;
                            setState(() {
                              isCard[index] = !isCard[index];
                            });
                          }),
                    ),
                  );
                },
                itemCount: products.length,
              ),
      ),
    );
  }
}
