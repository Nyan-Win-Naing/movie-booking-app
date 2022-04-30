import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class FormStyleView extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPasswordField;
  final bool isNumber;

  final TextEditingController? textController;

  final String keyName;

  FormStyleView(
    this.label,
    this.hintText, {
    this.isPasswordField = false,
    this.isNumber = false,
    this.textController,
    this.keyName = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: SUBSCRIPTION_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
        const SizedBox(height: MARGIN_MEDIUM),
        TextField(
          key: Key(keyName),
          controller: textController,
          keyboardType: isNumber ? TextInputType.number : null,
          obscureText: isPasswordField,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: TEXT_FIELD_HINT_COLOR),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: TEXT_FIELD_HINT_COLOR),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: TEXT_FIELD_HINT_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
