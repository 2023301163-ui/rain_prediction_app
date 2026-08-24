class AnalyticsData {
  const AnalyticsData({
    required this.todayRainfallMmHr,
    required this.highestWaterLevelM,
    required this.floodAlertsCount,
    required this.smsSentCount,
    required this.recentEvents,
  });

  final double todayRainfallMmHr;
  final double highestWaterLevelM;
  final int floodAlertsCount;
  final int smsSentCount;
  final List<AnalyticsEvent> recentEvents;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['recent_events'] as List<dynamic>? ?? const <dynamic>[];

    return AnalyticsData(
      todayRainfallMmHr: (json['today_rainfall_mm_hr'] as num?)?.toDouble() ?? 0.0,
      highestWaterLevelM: (json['highest_water_level_m'] as num?)?.toDouble() ?? 0.0,
      floodAlertsCount: (json['flood_alerts_count'] as num?)?.toInt() ?? 0,
      smsSentCount: (json['sms_sent_count'] as num?)?.toInt() ?? 0,
      recentEvents: eventsJson
          .map((item) => AnalyticsEvent.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AnalyticsEvent {
  const AnalyticsEvent({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.iconName,
    required this.colorHex,
  });

  final String title;
  final String subtitle;
  final String time;
  final String iconName;
  final String colorHex;

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      iconName: json['icon_name']?.toString() ?? 'notifications_active',
      colorHex: json['color_hex']?.toString() ?? '#FF9800',
    );
  }
}
