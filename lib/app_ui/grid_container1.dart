import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/component/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';

class grid_container1 extends StatefulWidget {
  final String? images, title;
  final VoidCallback? onPressed;
  final Widget? widgets;

  const grid_container1(
      {super.key, this.images, this.title, this.onPressed, this.widgets});

  @override
  State<grid_container1> createState() => _grid_container1State();
}

class _grid_container1State extends State<grid_container1> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.6), width: 0.8),
                  // image: DecorationImage(image: NetworkImage(widget.images.toString()),fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(1, 5),
                    )
                  ]),
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black45),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                        child: Text(
                      widget.title.toString(),
                      style: appTextstyle.normalText(
                          Colors: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    )),
                  )),
            ),
            // Align(alignment: Alignment.topLeft,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: widget.widgets,
            //     ))
          ],
        ),
      ),
    );
  }
}
