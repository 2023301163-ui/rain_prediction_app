import 'package:flutter/material.dart';
import 'analytics.dart';

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
          NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),
          NavigationDestination(icon: Icon(Icons.analytics_rounded), label: "Analytics"),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),

      appBar: AppBar(
        title: const Text("Rainfall Monitoring"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const ListTile(
              leading: Icon(Icons.location_on, color: Colors.red),
              title: Text("Barangay San Isidro"),
              subtitle: Text("Current Monitoring Area"),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: const Column(
              children: [
                Icon(Icons.cloud, color: Colors.white, size: 65),

                SizedBox(height: 15),

                Text(
                  "18.4 mm/hr",
                  style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 5),

                Text("Current Rainfall", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: infoCard(Icons.warning, Colors.orange, "MODERATE", "Flood Risk")),

              const SizedBox(width: 10),

              Expanded(child: infoCard(Icons.water_drop, Colors.blue, "0.75 m", "Water Level")),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: infoCard(Icons.thermostat, Colors.red, "29°C", "Temperature")),

              const SizedBox(width: 10),

              Expanded(child: infoCard(Icons.opacity, Colors.cyan, "86%", "Humidity")),
            ],
          ),

          const SizedBox(height: 20),

          const Text("Latest Alert", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          Card(
            color: Colors.red.shade50,
            child: const ListTile(
              leading: Icon(Icons.warning_amber, color: Colors.red, size: 40),
              title: Text("Moderate Rainfall Detected"),
              subtitle: Text("Residents are advised to stay alert for possible flooding."),
            ),
          ),

          const SizedBox(height: 20),

          const Text("Sensor Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          sensorTile("Rain Gauge", true),
          sensorTile("Water Level Sensor", true),
          sensorTile("ESP32 Controller", true),
          sensorTile("Internet Connection", true),

          const SizedBox(height: 30),
        ],
      ),
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
          online ? "Online" : "Offline",
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
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              subtitle: const Text("Administrator"),
            ),
          ),

          Card(
            child: ListTile(leading: const Icon(Icons.notifications), title: const Text("Notifications")),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              subtitle: const Text("Version 1.0"),
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
