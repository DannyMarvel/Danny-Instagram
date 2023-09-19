import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tentacles/resources/storage_method.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String postId = Uuid().v1(); 
//Now we create a function to upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'some error occured';
    try {
//This how we create a folder for storage for posts on firebase
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
//Now we need a unquie id for every postId.
//v1 creates a unquie id for each per time
      String postId = Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        //Note this datePublished with post.dart
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      //Now we can take post and upload to firebase,
      //Because we have created a file posts to our firebaseStorage.
//Then we upload post on posts collection and set post.tojson
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

//To see the like animation in the small love place
//We write a function under the firebasefirestore
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
//.update means we are changing only one value
//Now we tell firebase to remove the current uid from the likes array
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
//.update means we are changing only one value
//Now we tell firebase to add the current uid to the likes array
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
//Then we print any exceptional error in string format
      print(e.toString());
    }
  }

//Now when we click on post we should save our data in firebase database
//Also when we click on the username we get to their profile
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePics) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePics,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

//Now we create a function to delete a POST
  Future<void> deletePost(String postId) async {
    try {
//This is how to delete a post from a collection
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

//Now we create a function to follow users
//We need to get the uid and the followid
  Future<void> followUser(String uid, String followId) async {
    try {
//Now we get the uid of users from the colection of users
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
//If the person following contains the followId,
//It means we are following the person, the we remove the follow
        await _firestore.collection('users').doc(followId).update({
          //This means we have remove a follower from the user
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
//Now we remove the followId from the following
          //This means we have remove a following from a user
          'following': FieldValue.arrayRemove([followId])
        });
      } else
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId])
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
