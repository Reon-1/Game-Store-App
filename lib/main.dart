import 'package:ecommerce/screens/HomeScreen.dart';
import 'package:ecommerce/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'Provider/MainProvider.dart';

String token;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");
  runApp(
    ChangeNotifierProvider(create: (context) => MainProvider(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dokan',
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
  String bearerToken;

  @override
  Widget build(BuildContext context) {
    token = token == null ? "" : token;
    return Scaffold(body: token.length > 0 ? HomeScreen() : LoginScreen());
  }
}
