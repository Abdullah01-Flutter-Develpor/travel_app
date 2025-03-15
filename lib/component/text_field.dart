
import 'package:flutter/material.dart';
import 'package:travel_app/component/text_style.dart';


class customTextField extends StatefulWidget {
  final TextEditingController? Controller;
  final FormFieldValidator? validator;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? TextInputTypes;
  final int? maxLines;
  final String? initialValue;
  final bool? enabled;

  const customTextField({super.key,  this.Controller,  this.validator, this.labelText,  this.prefixIcon,  this.suffixIcon, this.obscureText, this.maxLines, this.TextInputTypes, this.initialValue, this.enabled = true });

  @override
  State<customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<customTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      keyboardType: widget.TextInputTypes,
      maxLines: widget.maxLines,
      validator: widget.validator,
      controller: widget.Controller,
      obscureText: widget.obscureText!,
      enabled: widget.enabled,
      style: appTextstyle.normalText(fontSize: 16),
      decoration: InputDecoration(
        labelStyle: appTextstyle.normalText(),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Colors.grey.withOpacity(0.1)),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),

            borderRadius: const BorderRadius.all(Radius.circular(5))),
      ),

    );
  }
}
