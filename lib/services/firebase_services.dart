import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  String? getCurrentUserName() {
    return _firebaseAuth.currentUser!.displayName;
  }

  String? getCurrentEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('Products');

  final CollectionReference usersCartRef = FirebaseFirestore.instance
      .collection(
          'Users'); // TO STORE USERS CART | User-->userId->Cart-->productId

  final CollectionReference usersCartHistoryRef =
      FirebaseFirestore.instance.collection("UsersCartHistory");

  final CollectionReference userDetailsRef =
      FirebaseFirestore.instance.collection("UserDetails");

 static Future<void> addUserToFirestore(String name, String email, String uid ) async {
    try {
      // Get a reference to the Firestore collection
      final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Add user data to Firestore
      await userRef.set({
        'id':uid,
        'name': name,
        'email': email,
        // Add any additional fields as needed
      });

      print('User added to Firestore successfully.');
    } catch (error) {
      print('Error adding user to Firestore: $error');
    }
  }

  Future<void> userSetup(String displayName) async {
    CollectionReference users = _firebaseFirestore.collection('UserDetails');

    String uid = getCurrentEmail().toString();
    String displayName = getCurrentUserName().toString();

    users.doc(getUserId()).set({'displayName': displayName, 'uid': uid});
    return;
  }
}
