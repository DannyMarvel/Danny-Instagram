import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tentacles/utils/colors.dart';
import 'package:tentacles/utils/global_variables.dart';
import './profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(labelText: 'Search for a user'),
//Since we do not have a submit button, we check if it is submitted
          onFieldSubmitted: (String _) {
            setState(() {
//isShowUsers will on be true when the field is submitted
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
//Now we wrap the ListTile with an InkWell
//so when we click  on it we go to the person profile
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
//We take a quick snapShot from the uid
//If were are not following it will show follow
//Else it will show Unfollow
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                        ),
                        title: Text((snapshot.data! as dynamic).docs[index]
                            ['username']),
                      ),
                    );
                  },
                );
              },
//Now we use .where to get the exact field we want
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
//NOTE only version 0.3.1 works for FLUTTER STAGGERED.
                return StaggeredGridView.countBuilder(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ),
                    staggeredTileBuilder: (int index) =>
                        MediaQuery.of(context).size.width > webScreenSize
                            ? StaggeredTile.count(
                                //If the image we recieve is completely divisible by 7,
                                //Then we want a count of 2, Else 1
                                (index % 7 == 0) ? 1 : 1,
                                (index % 7 == 0) ? 1 : 1,
                              )
                            : StaggeredTile.count(
                                //If the image we recieve is completely divisible by 7,
                                //Then we want a count of 2, Else 1
                                (index % 7 == 0) ? 2 : 1,
                                (index % 7 == 0) ? 2 : 1,
                              ));
                // return Text('');
              }),
            ),
    );
  }
}
