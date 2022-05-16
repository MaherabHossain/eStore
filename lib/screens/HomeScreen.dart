import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:ecommerce/Widget/Banner.dart';
import 'package:ecommerce/screens/CartScreen.dart';
import 'package:ecommerce/screens/CategoryScreen.dart';
import 'package:ecommerce/screens/Productdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  }

  Future getProduct() async {
    final res = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    setState(() {
      products = jsonDecode(res.body);
      isCard = List.filled(products.length, false);
    });
  }

  @override
  void initState() {
    getCategories();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokan"),
        leading: Icon(Icons.menu),
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
                      builder: (context) => CartScreen(
                        cart: providerData.cart,
                      ),
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
              height: 40,
              child: Expanded(
                  child: categories.length > 0
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                var categoryProduct = [];
                                for (var i = 0; i < products.length; i++) {
                                  if (categories[index] ==
                                      products[i]['category']) {
                                    categoryProduct.add(products[i]);
                                  }
                                }

                                print(categoryProduct.length);
                                print(categories[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryScreen(
                                        products: categoryProduct,
                                        categoryName: categories[index]),
                                  ),
                                );
                              },
                              child: Container(
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
                        child: Image.network(
                          products[index]['image'],
                          fit: BoxFit.contain,
                        ),
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
                                products[index]['title'],
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
                              color:
                                  isCard[index] ? Colors.green : Colors.white,
                              size: 35,
                            ),
                            onPressed: () {
                              !isCard[index]
                                  ? providerData.addtTocart(products[index])
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
    );
  }
}
