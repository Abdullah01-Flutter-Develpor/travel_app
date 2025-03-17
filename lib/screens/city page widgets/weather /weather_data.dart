class WeatherData {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconUrl;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
    );
  }
}
