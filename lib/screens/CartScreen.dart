import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key, this.cart}) : super(key: key);
  final cart;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.cart.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String productName = "";
          if (widget.cart[index]['title'].length > 15) {
            for (var i = 0; i < 15; i++) {
              productName += widget.cart[index]['title'][i];
            }
            productName += "...";
          } else {
            productName = widget.cart[index]['title'];
          }
          print(productName);
          return Container(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    widget.cart[index]['image'],
                  ),
                  title: Text(productName),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.cart.remove(widget.cart[index]);
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: widget.cart.length,
      ),
    );
  }
}
