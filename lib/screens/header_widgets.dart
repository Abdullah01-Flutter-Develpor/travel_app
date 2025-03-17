import 'package:flutter/material.dart';

class HeaderWidgets extends StatelessWidget {
  const HeaderWidgets({
    super.key,
    required this.cityName,
  });

  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100], // Example background color
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Explore the beauty',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          // const CircleAvatar(
          //   radius: 30,
          //   backgroundImage: AssetImage('assets2/images/hunza.jpg'),
          // ),
        ],
      ),
    );
  }
}
