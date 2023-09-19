import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentacles/providers/user_provider.dart';
import '../utils/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
//init state is always here
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //This creates the responsive effects
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // Display web screen
          return widget.webScreenLayout;
        }
        // Else display a mobile screen
        return widget.mobileScreenLayout;
      },
    );
  }
}
