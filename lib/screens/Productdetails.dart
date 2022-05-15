import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key key, this.product}) : super(key: key);
  final product;
  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState(product: product);
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final product;
  _ProductDetailsScreenState({this.product});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Description"),
      ),
      body: product != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                    minHeight: 100,
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        product['image'],
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 8,
                        child: Container(
                          child: Text(
                            '109.5 \$',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100,
                      minHeight: 10,
                      maxHeight: 100),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, right: 9, left: 20),
                    child: Text(
                      product['title'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                    product['description'],
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Container(
                  width: 150,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3, top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      print('add to cart');
                    },
                    child: Row(
                      children: [
                        Text('Add to cart'),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.add_shopping_cart)
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
