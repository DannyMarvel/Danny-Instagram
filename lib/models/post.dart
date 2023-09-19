import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
//Note this datePublished  
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;
//We did not add the comment property, cause it will be a subCollection  

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

//Then we add some functions we can use for users on firebase
//This converts the required details to an object

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'profileImage': profileImage,
        'likes': likes,
        'postUrl': postUrl,
      };

//Now we convert our doccument snapshot to user model
//We taking a doccument snapshot and returning a user model
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      postUrl: snapshot['postUrl'],
    );
  }
}
