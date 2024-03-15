import 'package:flutter/material.dart';
import 'package:onlinegrocerystore/constants.dart';

//TEXT FIELD INPUT BOX
class CustomInput extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;
  final TextCapitalization? textCapitalization;
  final TextInputType? textInputType;
  final dynamic controller;
  final String Function(String? value)? validation;
  final Widget? suffix;

  const CustomInput(
      {Key? key,
      this.hintText="",
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField,
      this.controller,
      this.textCapitalization,
        this.validation,
        this.suffix,
      this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;

    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: Color(0xfff2f2f2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(

          controller: controller,
          obscureText: _isPasswordField,
          validator: validation??(v){
            if(v!.isEmpty){
              return "Please fill details";
        }
            return null;
          },
          focusNode: focusNode,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          textCapitalization: textCapitalization??TextCapitalization.characters,
          decoration: InputDecoration(

            suffixIcon: suffix??SizedBox(),
              border: InputBorder.none,
              hintText: hintText ?? "Hint Text...",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0)),
          style: Constants.regularDarkText,
        ));
  }
}
