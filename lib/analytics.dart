import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),

      appBar: AppBar(title: const Text("Analytics"), backgroundColor: Colors.blue, foregroundColor: Colors.white),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Monitoring Summary", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: summaryCard(Icons.cloud, Colors.blue, "18.4 mm/hr", "Today's Rainfall")),

              const SizedBox(width: 10),

              Expanded(child: summaryCard(Icons.water_drop, Colors.cyan, "0.92 m", "Highest Water Level")),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: summaryCard(Icons.warning, Colors.red, "5", "Flood Alerts")),

              const SizedBox(width: 10),

              Expanded(child: summaryCard(Icons.sms, Colors.orange, "18", "SMS Sent")),
            ],
          ),

          const SizedBox(height: 25),

          const Text("Recent Events", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          eventTile(Icons.warning, Colors.red, "Flood Warning", "Water level reached 0.92 m.", "Today • 2:45 PM"),

          eventTile(Icons.cloud, Colors.blue, "Heavy Rainfall", "Rainfall reached 18.4 mm/hr.", "Today • 2:15 PM"),

          eventTile(
            Icons.notifications_active,
            Colors.orange,
            "Early Warning Sent",
            "SMS alert sent to residents.",
            "Today • 2:10 PM",
          ),

          eventTile(
            Icons.water,
            Colors.cyan,
            "Water Level Increased",
            "River water level increased to 0.75 m.",
            "Today • 1:55 PM",
          ),

          eventTile(
            Icons.check_circle,
            Colors.green,
            "System Normal",
            "All monitoring sensors are online.",
            "Today • 1:30 PM",
          ),

          const SizedBox(height: 25),
        ],
      ),
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

  static Widget eventTile(IconData icon, Color color, String title, String subtitle, String time) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(subtitle),

        trailing: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ),
    );
  }
}
