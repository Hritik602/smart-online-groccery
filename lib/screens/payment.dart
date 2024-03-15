import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinegrocerystore/constants.dart';
import 'package:onlinegrocerystore/screens/existing_card_page.dart';
import 'package:onlinegrocerystore/screens/home.dart';


class PaymentPage extends StatefulWidget {
  final double total;

  const PaymentPage({  Key? key, required this.total}) : super(key: key);

  @override
  _ExistingCardsPageState createState() => _ExistingCardsPageState();
}

class _ExistingCardsPageState extends State<PaymentPage> {
  //ON PRESSED ON CARDS
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
      //  payViaNewCard(context);
        break;
      //DIRECTING TO PAY WITH EXISTING CARD PAGE
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExistingCardPage(
            total: widget.total,
          )),
        );
        break;
    }
  }

  // payViaNewCard(BuildContext context) async {
  //   ProgressDialog dialog = new ProgressDialog(context);
  //   dialog.style(
  //       message: 'Please wait...'
  //   );
  //   await dialog.show();
  //   // var response = await StripeService.payWithNewCard(
  //   //     amount: '${widget.total.toStringAsFixed(0)}00', currency: 'LKR'); //get total price
  //   await dialog.hide();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(response.message),
  //     duration:
  //     Duration(milliseconds: response.success == true ? 1200 : 3000),
  //   )).closed.then((_) {
  //     if (response.success) {
  //       print(widget.total);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //       );
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
   // StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment",
            style: Constants.boldHeadingAppBar,
          ),
          leading: Icon(Icons.monetization_on_rounded),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.separated(
              itemBuilder: (context, index) {
                Icon icon;
                Text text;

                switch (index) {
                  case 0:
                    icon = Icon(Icons.add_rounded,
                        color: Theme.of(context).primaryColor);
                    text = Text("Pay via new card");
                    break;

                  case 1:
                    icon = Icon(Icons.credit_card_rounded,
                        color: Theme.of(context).primaryColor);
                    text = Text("Pay via existing card");
                    break;
                }
                return InkWell(
                  child: ListTile(
                    onTap: () {
                      onItemPress(context, index);
                    },
                    title: Text(""),
                    leading: SizedBox(),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).primaryColor,
                  ),
              itemCount: 2),
        ),
      ),
    );
  }
}
