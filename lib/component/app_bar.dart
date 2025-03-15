import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travel_app/component/text_style.dart';

class appBar extends StatefulWidget {
  final double? latitude,longitude;
  const appBar({super.key, this.latitude, this.longitude});

  @override
  State<appBar> createState() => _appBarState();
}

class _appBarState extends State<appBar> {

  String _address = 'Unknown';
  Future<void> _convertCoordinatesToAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(widget.latitude.toString()), double.parse(widget.longitude.toString()));
      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _address = "Error: $e";
      });
    }
  }
  @override
  void initState() {
    _convertCoordinatesToAddress();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Container(
      child:  Text(_address.toString(),style: appTextstyle.normalText(Colors: Colors.white,fontSize: 25),maxLines: 3,),
    );
  }
}
