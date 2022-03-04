import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          text,
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ),
      );
    },
  );
}