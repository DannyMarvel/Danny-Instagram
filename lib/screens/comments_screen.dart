import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tentacles/resources/firestore_method.dart';
import 'package:tentacles/utils/colors.dart';
import '../widgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:tentacles/models/users.dart';
import 'package:tentacles/providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Now we use the UserProvider to set things automatically
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Comments'),
          centerTitle: false,
        ),
        body: StreamBuilder(
          //We wrap with StreamBuilder instead of making commentCard() as the body
//In the stream we pass in a sub collection of stream
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
//The Newest comment will be on the Top
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              //STILL THE SAME;  itemCount: snapshot.data!.docs.length,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
//Now we pass in the snapShot of the streamBuilder
                  snap: (snapshot.data! as dynamic).docs[index].data()),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
//Now our comments have been stored in our database succesfully
                    await FirestoreMethods().postComment(
                      widget.snap['postId'],
//Now we pick the text to firebase
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl,
                    );
                    setState(() {
//Now we set the textField to null
                      _commentController.text = ' ';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      'post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
