import 'dart:async';
import 'package:flutter/material.dart';
import 'models/analytics_data.dart';
import 'services/analytics_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AnalyticsService _service = AnalyticsService();
  Timer? _refreshTimer;
  AnalyticsData? _analyticsData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) => _loadAnalytics());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    try {
      final analyticsData = await _service.fetchAnalytics();
      if (!mounted) return;
      setState(() {
        _analyticsData = analyticsData;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),
      appBar: AppBar(title: const Text('Analytics'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_analyticsData == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_errorMessage ?? 'Unable to load analytics data.', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _loadAnalytics, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final data = _analyticsData!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Monitoring Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: summaryCard(Icons.cloud, Colors.blue, '${data.todayRainfallMmHr.toStringAsFixed(1)} mm/hr', 'Today\'s Rainfall')),
            const SizedBox(width: 10),
            Expanded(child: summaryCard(Icons.water_drop, Colors.cyan, '${data.highestWaterLevelM.toStringAsFixed(2)} m', 'Highest Water Level')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: summaryCard(Icons.warning, Colors.red, data.floodAlertsCount.toString(), 'Flood Alerts')),
            const SizedBox(width: 10),
            Expanded(child: summaryCard(Icons.sms, Colors.orange, data.smsSentCount.toString(), 'SMS Sent')),
          ],
        ),
        const SizedBox(height: 25),
        const Text('Recent Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...data.recentEvents.map((event) => eventTile(event)),
        const SizedBox(height: 25),
      ],
    );
  }

  static Widget summaryCard(IconData icon, Color color, String value, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, color: color, size: 38),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  static Widget eventTile(AnalyticsEvent event) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _colorFromHex(event.colorHex).withValues(alpha: 0.15),
          child: Icon(_iconFromName(event.iconName), color: _colorFromHex(event.colorHex)),
        ),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(event.subtitle),
        trailing: Text(event.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ),
    );
  }

  static IconData _iconFromName(String name) {
    switch (name) {
      case 'warning':
        return Icons.warning;
      case 'cloud':
        return Icons.cloud;
      case 'water':
        return Icons.water;
      case 'check_circle':
        return Icons.check_circle;
      case 'sms':
        return Icons.sms;
      default:
        return Icons.notifications_active;
    }
  }

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
