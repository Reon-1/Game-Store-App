import 'dart:async';
import 'dart:ffi';
import 'package:path/path.dart';
import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:ecommerce/Widget/Banner.dart';
import 'package:ecommerce/Widget/MyDrawer.dart';
import 'package:ecommerce/screens/CartScreen.dart';
import 'package:ecommerce/screens/CategoryScreen.dart';
import 'package:ecommerce/screens/Productdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // print(globals.baseUrl);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List categories = [];

  List products = [];
  List isCard;
  bool productLoader = true;
  // get categories
  Future getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String bearerToken = "Bearer $token";
    final res =
        await http.get(Uri.parse('${globals.baseUrl}api/categories'), headers: {
      'Authorization': bearerToken,
    });
    if (res.statusCode == 200) {
      if (res.body.isNotEmpty) {
        setState(() {
          categories = jsonDecode(res.body);
          // print(bearerToken);
        });
      }
      // print(res.body);
    }
  }

  // get product
  Future getProduct() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      String bearerToken = "Bearer $token";
      final res =
          await http.get(Uri.parse('${globals.baseUrl}api/products'), headers: {
        'Authorization': bearerToken,
      }).timeout(Duration(seconds: 30), onTimeout: () {
        Toast.show("Request time out. try again!",
            duration: Toast.lengthShort, gravity: Toast.bottom);
        return null;
      });
      if (res.statusCode == 200) {
        setState(() {
          products = jsonDecode(res.body);
          isCard = List.filled(products.length, false);
        });
      }
      setState(() {
        // print(products);
        productLoader = false;
      });
    } catch (e) {}
  }

  //initState
  @override
  void initState() {
    getCategories();
    getProduct();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final providerData = Provider.of<MainProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Dokan"),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _key.currentState.openDrawer();
            }),
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
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerImage(),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
              child: categories != null
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            var id = categories[index]['id'];
                            String name = categories[index]['name'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                  id: id,
                                  categoryName: name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10), // <= No more error here :)
                              color: Colors.grey,
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              categories[index]['name'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      },
                      itemCount: categories.length,
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Text(
                "Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: productLoader
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
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            footer: GridTileBar(
                              backgroundColor: Colors.black54,
                              title: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
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
                                    color: isCard[index]
                                        ? Colors.green
                                        : Colors.white,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    // int price = double.tryParse(
                                    //         products[index]['price']) ??
                                    //     products[index]['price'];
                                    String a = "4";
                                    String b = "5";

                                    double price =
                                        double.parse(products[index]['price']);
                                    // print(price);
                                    int d = int.parse(a) + int.parse(b);
                                    // print(d); //puutput: 9
                                    !isCard[index]
                                        ? providerData.addtTocart({
                                            "id": products[index]['id'],
                                            "name": products[index]['name'],
                                            "image_url1": products[index]
                                                ['image_url1'],
                                            "price": price,
                                            "quantity": 1,
                                            'total': price
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
            )
          ],
        ),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: MyDrawer(),
      ),
    );
  }
}
