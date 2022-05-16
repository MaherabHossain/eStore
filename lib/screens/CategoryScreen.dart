import 'package:ecommerce/Provider/MainProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CartScreen.dart';
import 'Productdetails.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key, this.products, this.categoryName})
      : super(key: key);
  final categoryName;
  final products;
  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState(categoryName: categoryName, products: products);
}

class _CategoryScreenState extends State<CategoryScreen> {
  _CategoryScreenState({this.products, this.categoryName});
  final products;
  String categoryName;
  List isCard;

  void initState() {
    super.initState();
    setState(() {
      if (products != null) {
        isCard = List.filled(products.length, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.products);
    final providerData = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName != null ? categoryName : ""),
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
      body: products != null
          ? Padding(
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
                            color: isCard[index] ? Colors.green : Colors.white,
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
            )
          : Container(
              child: Text('no produtc'),
            ),
    );
  }
}
