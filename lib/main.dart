import 'package:ecommerce/screens/HomeScreen.dart';
import 'package:ecommerce/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'Provider/MainProvider.dart';

void main() {
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
  String bearerToken;
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      setState(() {
        bearerToken = token;
      });
    } else {
      bearerToken = token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bearerToken != null ? HomeScreen() : LoginScreen(),
    );
  }
}
