import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:ecommerce/screens/PlaceOrder.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'HomeScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future placeOrder() async {}
  _CartScreenState({Key key});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final providerData = Provider.of<MainProvider>(context);
    final cart = providerData.cart;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              String productName = "";
              if (cart[index]['name'].length > 15) {
                for (var i = 0; i < 7; i++) {
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
                        width: 40,
                        imageUrl: "${globals.baseUrl}image/" +
                            cart[index]['image_url1'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                        width: 60,
                        child: Text(
                          productName,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            cart[index]['quantity']++;
                            print(cart[index]['price'].runtimeType);

                            cart[index]['total'] =
                                cart[index]['quantity'] * cart[index]['price'];
                          });
                        },
                      ),
                      Text("${cart[index]['quantity']}"),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (cart[index]['quantity'] != 1) {
                            setState(() {
                              cart[index]['quantity']--;
                              cart[index]['total'] = cart[index]['quantity'] *
                                  cart[index]['price'];
                              print(cart[index]['price']);
                            });
                          } else {
                            Toast.show("Quantity can't be less then one",
                                duration: Toast.lengthShort,
                                gravity: Toast.bottom);
                          }
                        },
                      ),
                      Container(
                        width: 60,
                        child: Text(
                          "${cart[index]['total']} " + ' \$',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 25,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              cart.remove(cart[index]);
                            });
                            Toast.show("Product removed!",
                                duration: Toast.lengthShort,
                                gravity: Toast.bottom);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: cart.length,
          ),
          cart.length > 0
              ? Positioned(
                  bottom: 0,
                  right: MediaQuery.of(context).size.width / 2.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceOrder(),
                        ),
                      );
                    },
                    child: Text("Process To Order"),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
