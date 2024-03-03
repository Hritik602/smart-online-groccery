import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinegrocerystore/screens/cart_history.dart';
import 'package:onlinegrocerystore/screens/shopping_cart.dart';
import 'package:onlinegrocerystore/screens/shopping_list.dart';
import 'package:onlinegrocerystore/widgets/app_drawer.dart';
import 'package:onlinegrocerystore/widgets/bottom_tabs.dart';
import 'package:onlinegrocerystore/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Home',
            style: Constants.boldHeadingAppBar,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          toolbarHeight: 200.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage("assets/image2.png"), fit: BoxFit.cover)),
          ),
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 30.0,
                    left: 30.0,
                  ),
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "What do you want to do?",
                    textAlign: TextAlign.left,
                    style: Constants.boldHeading,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      HomeNavigateTabs(
                        text: "Create a Shopping List",
                        iconData: Icons.assignment_turned_in_rounded,
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShoppingListPage()),
                            );
                          });
                        },
                      ),
                      HomeNavigateTabs(
                        text: "Check Cart History",
                        iconData: Icons.history,
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BillHistoryPage()),
                            );
                          });
                        },
                      ),
                      HomeNavigateTabs(
                        text: "Let's Start Shopping!",
                        iconData: Icons.shopping_cart_rounded,
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShoppingCartPage()),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
