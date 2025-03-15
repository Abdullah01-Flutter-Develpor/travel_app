import 'package:flutter/material.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/text_style.dart';

class appButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onPressed;
  final bool? loading;
  final Color? color;
  const appButton(
      {super.key,
      this.title,
      this.onPressed,
      this.loading = false,
      this.color = appColors.blueColor});

  @override
  State<appButton> createState() => _appButtonState();
}

class _appButtonState extends State<appButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: 50,
        width: double.infinity,
        child: Center(
          child: widget.loading == true
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  widget.title.toString(),
                  style: appTextstyle.normalText(Colors: Colors.white),
                ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.color,
        ),
      ),
    );
  }
}
