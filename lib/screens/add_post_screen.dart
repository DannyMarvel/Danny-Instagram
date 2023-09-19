import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tentacles/providers/user_provider.dart';
import 'package:tentacles/utils/colors.dart';
import 'package:tentacles/utils/utils.dart';

import '../models/users.dart';
import '../resources/firestore_method.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
//Now we create a global variable and first set _file to null
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

//Now we create a function for post image
  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
//SetState will load first will we await firebase
    setState(() {
      _isLoading = true;
    });

    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profileImage,
      );

      if (res == 'success') {
//if it successful then setState will be false
        setState(() {
          _isLoading = false;
        });

//We let the user know the image has been posted
        showSnackBar('Posted!!', context);
        clearImage();
      } else {
        showSnackBar(res, context);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

//Now we create a file selection function
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('create a Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a Photo'),
                onPressed: () async {
                  //We first dismiss the dialog box
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
//Then we rebuild _file here via setstate
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Choose from Gallery'),
                onPressed: () async {
                  //We first dismiss the dialog box
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  log(file.toString());
            
                  //Then we rebuild _file here via setstate
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () {
//Navigator.of(context) cancels a pop menu
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.arrow_back),
              ),
              title: Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
//Now we want to show a linearProgressIndicator
                _isLoading
                    ? const LinearProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(top: 0),
                      ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
//width = Total width of screen * 0.3
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
//To display a Un8List file we do not use NetworkImage
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
