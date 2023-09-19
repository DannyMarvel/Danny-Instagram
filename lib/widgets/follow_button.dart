import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
//Note this compulsory required function method
//Also function should be this. instead of required this.
//Because our function can be a nullable value
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  const FollowButton(
      {super.key,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      padding: EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
