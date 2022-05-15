import 'package:ecommerce/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'Provider/MainProvider.dart';
import 'Widget/Banner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => MainProvider(), child: MyApp()));
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
  var categories = [];

  var products = [];
  List isCard;
  Future getCategories() async {
    final res = await http
        .get(Uri.parse('https://fakestoreapi.com/products/categories'));
    setState(() {
      categories = jsonDecode(res.body);
    });
    print(categories[0]);
  }

  Future getProduct() async {
    final res = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    setState(() {
      products = jsonDecode(res.body);
      isCard = List.filled(products.length, false);
    });
    print(products[0]['title']);
  }

  @override
  void initState() {
    getCategories();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeScreen());
  }
}
