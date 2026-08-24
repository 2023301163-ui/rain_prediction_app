class RainData {
  const RainData({
    required this.area,
    required this.rainfallMmHr,
    required this.floodRisk,
    required this.waterLevelM,
    required this.temperatureC,
    required this.humidityPercent,
    required this.alertTitle,
    required this.alertMessage,
    required this.sensors,
  });

  final String area;
  final double rainfallMmHr;
  final String floodRisk;
  final double waterLevelM;
  final double temperatureC;
  final double humidityPercent;
  final String alertTitle;
  final String alertMessage;
  final List<SensorStatus> sensors;

  factory RainData.fromJson(Map<String, dynamic> json) {
    final sensorsJson = json['sensors'] as List<dynamic>? ?? const <dynamic>[];

    return RainData(
      area: json['area']?.toString() ?? 'Monitoring Area',
      rainfallMmHr: (json['rainfall_mm_hr'] as num?)?.toDouble() ?? 0.0,
      floodRisk: json['flood_risk']?.toString() ?? 'Normal',
      waterLevelM: (json['water_level_m'] as num?)?.toDouble() ?? 0.0,
      temperatureC: (json['temperature_c'] as num?)?.toDouble() ?? 0.0,
      humidityPercent: (json['humidity_percent'] as num?)?.toDouble() ?? 0.0,
      alertTitle: json['alert_title']?.toString() ?? 'All clear',
      alertMessage: json['alert_message']?.toString() ?? 'No active alert.',
      sensors: sensorsJson
          .map((item) => SensorStatus.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SensorStatus {
  const SensorStatus({required this.name, required this.online});

  final String name;
  final bool online;

  factory SensorStatus.fromJson(Map<String, dynamic> json) {
    return SensorStatus(
      name: json['name']?.toString() ?? 'Sensor',
      online: json['online'] as bool? ?? false,
    );
  }
}
