class Hotel {
  final String hotelName;
  final String hotelAddress;
  final double hotelPerNightStay;
  final String hotelImage;

  Hotel({
    required this.hotelName,
    required this.hotelAddress,
    required this.hotelPerNightStay,
    required this.hotelImage,
  });

  // Convert a Hotel object into a Map (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'hotelName': hotelName,
      'hotelAddress': hotelAddress,
      'hotelPerNightStay': hotelPerNightStay,
      'hotelImage': hotelImage,
    };
  }

  // Create a Hotel object from a Map (from Firestore)
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hotelName: json['hotelName'],
      hotelAddress: json['hotelAddress'],
      hotelPerNightStay: json['hotelPerNightStay'],
      hotelImage: json['hotelImage'],
    );
  }
}
