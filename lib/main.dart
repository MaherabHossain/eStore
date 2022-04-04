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
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokan"),
        leading: Icon(Icons.menu),
        actions: [
          Container(
            child: IconButton(
                padding: EdgeInsets.only(right: 20),
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {}),
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
            Container(
              height: 35,
              child: Expanded(
                  child: categories.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // <= No more error here :)
                                color: Colors.grey,
                              ),
                              height: 100,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                categories[index],
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          },
                          itemCount: categories.length,
                        )
                      : Center(child: CircularProgressIndicator())),
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
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50),
                  itemBuilder: (context, index) {
                    return GridTile(
                      child: Image.network(
                        products[index]['image'],
                        fit: BoxFit.contain,
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index]['title'],
                            ),
                            Text(
                              "${products[index]['price'].toString()} ${new String.fromCharCodes(new Runes('\u0024'))}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () {}),
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
    );
  }
}
