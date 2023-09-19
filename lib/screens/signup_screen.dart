import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tentacles/resources/auth_method.dart';
import 'package:tentacles/screens/login_screen.dart';
import 'package:tentacles/utils/colors.dart';
import '../widgets/text_field_input.dart';
import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  //The _image is set to null at first
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    //To reset the controller as soon as the user is done.
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
//async makes a whole function a future
    Uint8List im = await pickImage(ImageSource.gallery);
    //Then we rebuild with setState
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res != 'success') {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: MediaQuery.of(context).size.width,

          height: MediaQuery.of(context).size.height,

          //Double.infinity takes the full width of the device
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //How to make the chidren and adjust to a starting position
                //NOTE!!! You cannnot have flexible, expanded, spacer directly under single scrollview
                // Flexible(
                //   child: Container(),
                //   flex: 2,
                // ),

                // svg image
                SvgPicture.asset(
                  'assets/images/instagram.wine.svg',
                  //color: primaryColor,
                  height: 10,
                ),
                //Then we have a  circular avatar
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            //For ios the image will crash check 1:29:53 for corrections
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://microbiology.ucr.edu/sites/default/files/styles/form_preview/public/blank-profile-pic.png?itok=4teBBoet'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),

                //Field input for username
                TextFieldInput(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  isPass: false,
                ),
                const SizedBox(height: 14),
                //for email
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  isPass: false,
                ),
                SizedBox(height: 14),
                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                SizedBox(height: 14),
                //Text field input for email
                //Text field input for password
                //button login
                //Signup button

                //For Bio input text field
                TextFieldInput(
                  hintText: 'Enter your Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  isPass: false,
                ),
                SizedBox(height: 14),

                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    //if _isLoading is true
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text('Sign Up'),
                    //double.infifnity gives the max possible value
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                // Flexible(
                //   child: Container(),
                //   flex: 2,
                // ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Text('Don\'t have an account?'),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Center(
                      child: Container(
                        child: Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
