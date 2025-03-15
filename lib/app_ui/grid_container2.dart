import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/component/text_style.dart';

class gridContainer2 extends StatefulWidget {
  final String? images, title;
  final VoidCallback? onPressed;
  const gridContainer2({super.key, this.images, this.title, this.onPressed});

  @override
  State<gridContainer2> createState() => _gridContainer2State();
}

class _gridContainer2State extends State<gridContainer2> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(2, 4),
                )
              ]),
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  color: Colors.transparent,
                  // image: DecorationImage(image: NetworkImage(widget.images.toString()),fit: BoxFit.cover),
                ),
                child: Container(
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.images.toString(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.title.toString(),
                      style: appTextstyle.normalText(
                          fontWeight: FontWeight.w500, Colors: Colors.black),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
