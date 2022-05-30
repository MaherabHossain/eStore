import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: PlaceOrder(),
  ));
}

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  void _validate() {
    _form.currentState.validate();
  }

  String name;
  String email;
  String address;
  String trxId;
  String phoneNumber;
  bool bkash = false;
  bool nagad = false;
  bool roket = false;
  String paymentNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billings Details'),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator:
                    ValidationBuilder().minLength(5).maxLength(50).build(),
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  labelText: 'Phone number',
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 1.7),
                child: Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        bkash = !bkash;
                        nagad = false;
                        roket = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: bkash ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Bkash",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        nagad = !nagad;
                        bkash = false;
                        roket = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: nagad ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Nagad",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        roket = !roket;
                        nagad = false;
                        bkash = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: roket ? Colors.pink.shade900 : Colors.pink,
                      ),
                      child: Text(
                        "Roket",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validate,
        tooltip: 'Next',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
