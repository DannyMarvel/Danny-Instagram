import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tentacles/resources/auth_method.dart';
import 'package:tentacles/screens/signup_screen.dart';
import 'package:tentacles/utils/colors.dart';
import 'package:tentacles/utils/global_variables.dart';
import 'package:tentacles/utils/utils.dart';
import '../widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    //To reset the controller as soon as the user is done.
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            );
          },
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SignupScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ?
              //Then we show the web Screen layout
              EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              //Else we show the mobile screen layout
              : EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          //Double.infinity takes the full width of the device
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //How to make the chidren and adjust to a starting position
              Flexible(
                child: Container(),
                flex: 2,
              ),
// svg image
              SvgPicture.asset(
                'assets/images/Instagram-wine.svg',
                //color: primaryColor,
                height: 64,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              SizedBox(height: 24),
              //Text field input for email
              //Text field input for password
              //button login
              //Signup button
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Text('log in'),
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
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  child: Text('Don\'t have an account?'),
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: navigateToSignUp,
                  child: Center(
                    child: Container(
                      child: Text(
                        'Sign Up',
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
    );
  }
}
