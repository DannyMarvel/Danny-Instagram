import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tentacles/resources/storage_method.dart';
import '../models/users.dart' as model;

class AuthMethods {
//Now we get an instance of the firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
//To add user to our database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

//Now a function to sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
//Then for a file,
    required Uint8List file,
  }) async {
    String res = 'Error 007, Abeg try again';

    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty ||
              // ignore: unnecessary_null_comparison
              file != null
//Then we register the user
          ) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
//This is creating a storage folder on firebase
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
//We now create a JSON file for users
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [].toString(),
          following: [].toString(),
        );

//Then we add user to our database
//Then create a collection for each users and set the data
//toJson returns a map for us an object
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

//         await _firestore.collection('users').doc(cred.user!.uid).set({
//           'username': username,
//           'uid': cred.user!.uid,
//           'email': email,
//           'bio': bio,
//           //Then followers will be a list of Uid of diff people
//           'followers': [],
//           'following': [],
//           'photoUrl': photoUrl,

// // OR WE USE THIS
// //await _firestore.collection('users').add({
// //           'username': username,
// //           'uid': cred.user!.uid,
// //           'email': email,
// //           'bio': bio,
// //           //Then followers will be a list of Uid of diff people
// //           'followers': [],
// //           'following': [], });
//         });
        res = 'success';
      }
    }
//Now we catch any firebase error
    // on FirebaseAuthException catch (err) {
    //   if (err.code == 'invalid-email') {
    //     res = 'The email is badly formatted';
    //   } else if (err.code == 'weak-password') {
    //     res = 'Password should be at least 6 characters long';
    //   }
    // }

    catch (err) {
      res = err.toString();
    }
    return res;
  }

//To create a function to login users
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error ocurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    }
    // on FirebaseAuthException catch (e){
    //  if(e.code == 'user-not-found'){ }
    //  }

    catch (err) {
      res = err.toString();
    }
    return res;
  }

//Now we write a function to signOut Users
  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
