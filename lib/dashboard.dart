import 'dart:async';
import 'package:flutter/material.dart';
import 'analytics.dart';
import 'models/rain_data.dart';
import 'services/rain_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomeScreen(), AnalyticsPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.analytics_rounded), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final RainService _rainService;
  Timer? _refreshTimer;
  RainData? _data;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _rainService = RainService();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) => _loadData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await _rainService.fetchLatestData();
      if (!mounted) return;
      setState(() {
        _data = data;
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
      appBar: AppBar(
        title: const Text('Rainfall Monitoring'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null || _data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Unable to load data right now.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final data = _data!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: Text(data.area),
            subtitle: const Text('Current Monitoring Area'),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const Icon(Icons.cloud, color: Colors.white, size: 65),
              const SizedBox(height: 15),
              Text(
                '${data.rainfallMmHr.toStringAsFixed(1)} mm/hr',
                style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text('Current Rainfall', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: infoCard(Icons.warning, Colors.orange, data.floodRisk.toUpperCase(), 'Flood Risk')),
            const SizedBox(width: 10),
            Expanded(
              child: infoCard(Icons.water_drop, Colors.blue, '${data.waterLevelM.toStringAsFixed(2)} m', 'Water Level'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: infoCard(Icons.thermostat, Colors.red, '${data.temperatureC.toStringAsFixed(0)}°C', 'Temperature'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: infoCard(Icons.opacity, Colors.cyan, '${data.humidityPercent.toStringAsFixed(0)}%', 'Humidity'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Latest Alert', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Card(
          color: Colors.red.shade50,
          child: ListTile(
            leading: const Icon(Icons.warning_amber, color: Colors.red, size: 40),
            title: Text(data.alertTitle),
            subtitle: Text(data.alertMessage),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Sensor Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...data.sensors.map((sensor) => sensorTile(sensor.name, sensor.online)),
        const SizedBox(height: 30),
      ],
    );
  }

  static Widget infoCard(IconData icon, Color color, String value, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title),
          ],
        ),
      ),
    );
  }

  static Widget sensorTile(String title, bool online) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle, size: 14, color: online ? Colors.green : Colors.red),
        title: Text(title),
        trailing: Text(
          online ? 'Online' : 'Offline',
          style: TextStyle(color: online ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),

      appBar: AppBar(title: const Text("Settings"), backgroundColor: Colors.blue, foregroundColor: Colors.white),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              subtitle: const Text("Version 1.0"),
            ),
          ),
        ],
      ),
    );
  }
}
