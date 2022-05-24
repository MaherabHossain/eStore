import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:ecommerce/Widget/Banner.dart';
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
  List categories = [];

  List products = [];
  List isCard;

  Future getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    print('here is token');
    print(token);
    String bearerToken = "Bearer 1|bQXdkeAX1Ib8q1FwBXU4tfiAL5LKD6asRHBWPLNO";
    final res = await http
        .get(Uri.parse('http://192.168.1.21:8000/api/categories'), headers: {
      'Authorization': bearerToken,
      'Accept': 'application/json',
    });
    setState(() {
      categories = jsonDecode(res.body);
      print(bearerToken);
    });
  }

  Future getProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String bearerToken = "Bearer $token";
    final res = await http
        .get(Uri.parse('http://192.168.1.21:8000/api/products'), headers: {
      'Authorization': bearerToken,
      'Accept': 'application/json',
    });

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
            Container(
              height: 40,
              child: Expanded(
                  child: categories != null
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              // onTap: () {
                              //   var categoryProduct = [];
                              //   for (var i = 0; i < products.length; i++) {
                              //     if (categories[index] ==
                              //         products[i]['category']) {
                              //       categoryProduct.add(products[i]);
                              //     }
                              //   }
                              //   print(categoryProduct.length);
                              //   print(categories[index]);
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => CategoryScreen(
                              //           products: categoryProduct,
                              //           categoryName: categories[index]),
                              //     ),
                              //   );
                              // },
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
                                  categories[index]['name'],
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
                        child: CachedNetworkImage(
                          imageUrl: "http://192.168.1.21:8000/image/" +
                              products[index]['image_url1'],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
