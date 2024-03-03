import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onlinegrocerystore/constants.dart';
import 'package:onlinegrocerystore/models/item.dart';
import 'package:onlinegrocerystore/screens/checking_page.dart';
import 'package:onlinegrocerystore/services/firebase_services.dart';
import 'package:onlinegrocerystore/widgets/bottom_tabs.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  List<Item> itemsList = [];

  double total = 0;
  double totalWeight = 0;

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  final String formatted = formatter.format(now);

  void scanQRCode() async {
    await FlutterBarcodeScanner.scanBarcode(
            '#1faa00', "Cancel", true, ScanMode.BARCODE)
        .then((value) {
      print(value);
      _firebaseServices.productsRef
          .where('barcode', isEqualTo: value)
          .get()
          .then((val) {
        itemsList.add(new Item(
          barcode: val.docs.first['barcode'],
          name: val.docs.first['name'],
          price: double.parse(val.docs.first['price'].toString()),
          weight: double.parse(val.docs.first['weight'].toString()),
          quantity: 1,
          photo: val.docs.first['image'],
        ));
        ScaffoldMessenger.of(context).showSnackBar(_snackBarItemAdded);
        getTotals();
      });
    });
  }

  void getTotals() {
    setState(() {
      totalWeight = 0;
      total = 0;
      itemsList.forEach((element) {
        total += element.price * element.quantity;
        totalWeight += element.weight * element.quantity;
      });
    });
  }

  final SnackBar _snackBarItemAdded =
      SnackBar(content: Text("Item added to cart"));
  final SnackBar _snackBarItemDeleted =
      SnackBar(content: Text("Item removed from cart"));

  @override
  void initState() {
    super.initState();
  }

  Future _addToCart() async {
    itemsList.forEach((element) async {
      await _firebaseServices.usersCartRef
          .doc(_firebaseServices.getUserId())
          .collection("Cart")
          .add({
        'barcode': element.barcode,
        'image': element.photo,
        'name': element.name,
        'quantity': element.quantity,
        'weight': element.weight,
        'price': element.price,
        'time': formatted,
      });
    });
  }

  Future _addToCartHistory() async {
    itemsList.forEach((element) async {
      await _firebaseServices.usersCartHistoryRef
          .doc(_firebaseServices.getUserId())
          .collection("Cart")
          .add({
        'barcode': element.barcode,
        'image': element.photo,
        'name': element.name,
        'quantity': element.quantity,
        'weight': element.weight,
        'price': element.price,
        'time': formatted,
      });
    });
  }

  Future _onProceedButtonPress() async {
    if (itemsList.isNotEmpty) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm Cart!'),
              content: Text(
                  'Confirm your cart before proceeding.\n\nTotal Price: LKR ${total.toString()}0'),
              actions: [
                TextButton(
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    setState(() {
                      _addToCartHistory();
                      _addToCart().then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckingPage(
                                    total: total,
                                    totalWeight: totalWeight,
                                  )),
                        );
                      });
                    });
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Oh Empty Cart!'),
              content: Text('Start scanning to add items.'),
              actions: [
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
    }
  }

  Future<bool> _onBackPressed() async {
    if (itemsList.isNotEmpty) {
      await _addToCart();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Shopping Cart",
            style: Constants.boldHeadingAppBar,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        body: ListView.builder(
          itemCount: itemsList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Dismissible(
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15.0),
                  ),
                  onDismissed: (val) {
                    itemsList.removeAt(index);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(_snackBarItemDeleted);
                    getTotals();
                  },
                  key: Key(UniqueKey().toString()),
                  child: ListTile(
                    leading: Image.network(itemsList[index].photo),
                    title: Text(itemsList[index].name),
                    subtitle: Text('LKR ' +
                        itemsList[index].price.toString() +
                        '    Quantity: ' +
                        itemsList[index].quantity.toString()),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_circle_outlined,
                        color: Color(0xff1faa00),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Change Quantity"),
                                actions: [
                                  TextButton(
                                      child: Text('OK',
                                          style: TextStyle(fontSize: 18)),
                                      onPressed: () {
                                        getTotals();
                                        Navigator.pop(context);
                                      }),
                                ],
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.add_circle_outline_rounded,
                                              color: Colors.blue,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              itemsList[index].quantity += 1;
                                              getTotals();
                                              //Navigator.pop(context);
                                            }),
                                        IconButton(
                                            icon: Icon(
                                              Icons
                                                  .remove_circle_outline_rounded,
                                              color: Colors.blue,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              if (itemsList[index].quantity >
                                                  1) {
                                                itemsList[index].quantity -= 1;
                                              }
                                              getTotals();
                                              //Navigator.pop(context);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  )),
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            right: 8.0,
          ),
          child: Container(
            height: 60.0,
            width: 60.0,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.qr_code_rounded),
              onPressed: () {
                scanQRCode();
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 120.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1.0,
                blurRadius: 20.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CartBottomTabBtn(
                onPressed: () {
                  _onProceedButtonPress();
                },
              ),
              cartBottomTabTotal(total),
            ],
          ),
        ),
      ),
    );
  }
}
