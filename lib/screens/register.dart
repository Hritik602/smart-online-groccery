import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinegrocerystore/screens/login.dart';
import 'package:onlinegrocerystore/services/firebase_services.dart';
import 'package:onlinegrocerystore/widgets/custom_button.dart';
import 'package:onlinegrocerystore/widgets/custom_input.dart';
import 'package:onlinegrocerystore/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  String _registerEmail = "";
  String _registerPassword = "";
  String _name="";

  //CREATE A NEW ACCOUNT
  Future<String> _createAccount() async {
    try {
    UserCredential credential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);

   debugPrint("Credentials - ${credential.user!.uid}");
    FirebaseServices.addUserToFirestore(_name,_registerEmail,credential.user!.uid);
      return "";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
      return e.message.toString();
    } catch (e) {
      return (e.toString());
    }
  }

  //DEFAULT LOADING STATE
  bool _registerFromLoading = false;

  void _submitForm() async {
    //SET THE FORM TO LOADING STATE
    setState(() {
      _registerFromLoading = true;
    });

    //RUN THE CREATE ACCOUNT METHOD
    String _createAccountFeedback = await _createAccount();
    if (_createAccountFeedback.isNotEmpty) {
      _alertDialogBuilder(_createAccountFeedback);

      //SET THE FORM TO REGULAR STATE
      setState(() {
        _registerFromLoading = false;
      });
    } else {
      //STRING WAS EMPTY -> HOME PAGE
      Navigator.pop(context);
    }
  }

  //FOCUS NODE FOR INPUT FIELDS
  late FocusNode _inputFocusNodePassword;

  //FOCUS ON TO THE TEXT FIELD
  @override
  void initState() {
    _inputFocusNodePassword = FocusNode();
    super.initState();
  }

  //FOCUS OFF FROM THE TEXT FIELD
  @override
  void dispose() {
    _inputFocusNodePassword.dispose();
    super.dispose();
  }

  bool isShowPassword =true;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text(
                    "Create A New Account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                SizedBox(height: 200,),
                CustomInput(
                  hintText: "Name...",
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.text,
                  onChanged: (value) {
                    _name = value;
                  },
                  onSubmitted: (value) {
                    _inputFocusNodePassword.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: "Email...",
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _registerEmail = value;
                  },
                  onSubmitted: (value) {
                    _inputFocusNodePassword.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    if (value?.isEmpty==true) {
                      return 'Please enter your email';
                    }
                    if (!isEmailValid(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return ""; // Return null if the input is valid
                  },
                ),
                CustomInput(
             suffix: IconButton(icon:isShowPassword?Icon(Icons.visibility,

             color: Colors.black,
             ) :Icon(Icons.visibility_off,

             color: Colors.black,
             ),onPressed: (){
               setState((){
                 isShowPassword=!isShowPassword;
               });
             },),
                  hintText: "Password...",
                  textCapitalization: TextCapitalization.none,
                  isPasswordField: isShowPassword,
                  onChanged: (value) {
                    _registerPassword = value;
                  },
                  onSubmitted: (value) {
                    _submitForm();
                  },
                  focusNode: _inputFocusNodePassword,
                ),
                CustomBtn(
                  text: "Create New Account",
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _registerFromLoading,
                  outlineBtn: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24.0,
                  ),
                  child: CustomBtn(
                    text: "Back to Login",
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },

                    outlineBtn: true, isLoading: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool isEmailValid(String email) {
    // Regular expression for validating email addresses
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
