import 'package:ecommerce/screens/CartScreen.dart';
import 'package:ecommerce/screens/HomeScreen.dart';
import 'package:ecommerce/screens/LoginScreen.dart';
import 'package:ecommerce/screens/OrderScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/Provider/globals.dart' as globals;
import 'package:toast/toast.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String name;
  String email;
  Future getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String prefName = prefs.getString('name');
    String prefEmail = prefs.getString('email');
    setState(() {
      name = prefName;
      email = prefEmail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://st2.depositphotos.com/1006318/5909/v/600/depositphotos_59094701-stock-illustration-businessman-profile-icon.jpg'),
            ),
            accountEmail: Text(email != null ? email : ""),
            accountName: Text(
              name != null ? name : "",
              style: TextStyle(fontSize: 20),
            ),
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text(
              'Cart',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => CartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_bar_chart),
            title: const Text(
              'Orders',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => OrderScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Are you sure!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        print('come');
                        final prefs = await SharedPreferences.getInstance();
                        final String token = prefs.getString('token');
                        String bearerToken = "Bearer $token";
                        final res = await http.post(
                            Uri.parse('${globals.baseUrl}api/user/logout'),
                            headers: {
                              'Authorization': bearerToken,
                            });
                        print(res.body);
                        print(res.statusCode);
                        if (res.statusCode == 200) {
                          print("come");
                          await prefs.setString('token', "");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        } else {
                          Navigator.pop(context, 'YES');
                          Toast.show("Something went wrong.try again!",
                              duration: Toast.lengthShort,
                              gravity: Toast.bottom);
                        }
                      },
                      child: const Text('YES'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'NO'),
                      child: const Text('NO'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
