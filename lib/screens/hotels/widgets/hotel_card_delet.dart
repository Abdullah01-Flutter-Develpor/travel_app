import 'package:flutter/material.dart';
import 'package:travel_app/screens/hotels/widgets/model_class.dart/model_class.dart';

class HotelCardWithDelete extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onDelete;
  final bool isDeleting;

  const HotelCardWithDelete({
    Key? key,
    required this.hotel,
    required this.onDelete,
    required this.isDeleting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hotel Image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  hotel.hotelImage,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 200),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name
                    Text(
                      hotel.hotelName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Hotel Address
                    Text(
                      hotel.hotelAddress,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),

                    // Price Per Night
                    Text(
                      '\$${hotel.hotelPerNightStay.toStringAsFixed(2)} per night',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Delete Button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: isDeleting ? null : onDelete,
              icon: isDeleting
                  ? const CircularProgressIndicator(color: Colors.red)
                  : const Icon(Icons.delete, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
