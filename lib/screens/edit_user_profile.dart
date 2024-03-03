import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinegrocerystore/services/firebase_services.dart';
import 'package:onlinegrocerystore/widgets/custom_button.dart';
import 'package:onlinegrocerystore/widgets/custom_input.dart';
import 'package:onlinegrocerystore/widgets/profile_avatar.dart';
import 'package:onlinegrocerystore/constants.dart';

class EditUserProfile extends StatefulWidget {
  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  FirebaseServices _firebaseServices = FirebaseServices();
  TextEditingController _usernameController = TextEditingController();

  Future _addDisplayName() async {
    User updateUser = FirebaseAuth.instance.currentUser as User;
    updateUser.updateProfile(displayName: _usernameController.text);
    _firebaseServices.userSetup(_usernameController.text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: Constants.boldHeadingAppBar,
        ),
        leading: Icon(Icons.edit),
        textTheme: GoogleFonts.poppinsTextTheme(),
        backgroundColor: Colors.blue,
        toolbarHeight: 80.0,
        elevation: 0.0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      Avatar(),
                      Positioned(
                        right: -10,
                        bottom: 0,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Color(0xfff5f6f9)),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.camera_alt_rounded,
                                  color: Color(0xff9a9a9c),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                children: [
                  Text(
                    _firebaseServices.getCurrentUserName() ??
                        "Display Name Here",
                    style: Constants.regularWhiteText,
                  )
                ],
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
              CustomInput(
                controller: _usernameController,
                hintText: "Edit Display Name...",
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomEditBtn(
                    text: "Cancel",
                    onPressed: () {
                      FocusScope.of(context).requestFocus(
                          FocusNode()); //CLOSING THE KEYBOARD BEFORE GOING TO NEXT PAGE
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                  CustomEditBtn(
                    text: "Save",
                    onPressed: () {
                      FocusScope.of(context).requestFocus(
                          FocusNode()); //CLOSING THE KEYBOARD BEFORE GOING TO NEXT PAGE
                      _addDisplayName();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
