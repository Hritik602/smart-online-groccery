import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlinegrocerystore/screens/register.dart';
import 'package:onlinegrocerystore/widgets/custom_button.dart';
import 'package:onlinegrocerystore/widgets/custom_input.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //ALERT DIALOG TO DISPLAY ERRORS
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  //FORM INPUT VALUES
  String _loginEmail = "";
  String _loginPassword = "";

  //CREATE A NEW ACCOUNT
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return "";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.');
      }
      return e.message.toString();
    } catch (e) {
      return (e.toString());
    }
  }

  //DEFAULT LOADING STATE
  bool _loginFromLoading = false;

  void _submitForm() async {
    //SET THE FORM TO LOADING STATE
    setState(() {
      _loginFromLoading = true;
    });

    //RUN THE CREATE ACCOUNT METHOD
    String _loginAccountFeedback = await _loginAccount();
    if (_loginAccountFeedback != null) {
      _alertDialogBuilder(_loginAccountFeedback);

      //SET THE FORM TO REGULAR STATE
      setState(() {
        _loginFromLoading = false;
      });
    }
  }

  //FOCUS NODE FOR INPUT FIELDS
  late FocusNode _inputFocusNodePassword;

  //FOCUS ON
  @override
  void initState() {
    _inputFocusNodePassword = FocusNode();
    super.initState();
  }

  //FOCUS OFF
  @override
  void dispose() {
    _inputFocusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                child: const Text(
                  "Welcome Shopper!\nLogin to your account",
                  textAlign: TextAlign.center,

                ),
              ),
              CustomInput(
                hintText: "Email...",
                textCapitalization: TextCapitalization.none,
                textInputType: TextInputType.emailAddress,
                onChanged: (value) {
                  _loginEmail = value;
                },
                onSubmitted: (value) {
                  _inputFocusNodePassword.requestFocus();
                },
                textInputAction: TextInputAction.next,
              ),
              CustomInput(
                hintText: "Password...",
                textCapitalization: TextCapitalization.none,
                onChanged: (value) {
                  _loginPassword = value;
                },
                onSubmitted: (value) {
                 // _submitForm();
                },
                focusNode: _inputFocusNodePassword,
                isPasswordField: true,
              ),
              CustomBtn(
                text: "Login",
                onPressed: () {
                  debugPrint("Clicked");
                  _submitForm();
                },
                isLoading: _loginFromLoading, outlineBtn: false,
              ),

              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                child: CustomBtn(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  outlineBtn: true, isLoading: false,
                ),
              ),
            ],
          ),
      ),
    );
  }
}
