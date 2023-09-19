import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

//To automatically store files on firebase
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //To get the UID
  final FirebaseAuth _auth = FirebaseAuth.instance;

//Now to add image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
//_storage.ref() is a pointer to the storage
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

//Then if we are posting we create a unqiue id for each
    if (isPost) {
//This how we get userid and also the postid seperately
//This is different from profile pics where the userid is the file name
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    File uint8ListToFile(Uint8List uint8list, String filePath) {
      // Create a File object with the provided file path
      final file = File(filePath);

      // Write the Uint8List data to the file
      file.writeAsBytesSync(uint8list);

      return file;
    }

//To create a seperate file for ref to upload
    try {
      UploadTask uploadTask1 =
          ref.putFile(uint8ListToFile(file, 'post/images'));
    } catch (e) {
      log(e.toString());
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
