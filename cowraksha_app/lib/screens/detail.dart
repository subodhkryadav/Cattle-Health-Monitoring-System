import 'package:flutter/material.dart';

class CowDetailScreen extends StatelessWidget {
  final Map<String, dynamic> cow;

  const CowDetailScreen({super.key, required this.cow});

  Color getColor(String s) {
    if (s == "Emergency") return Colors.red;
    if (s == "Critical") return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    double air = ((cow['co'] ?? 0) + (cow['ammonia'] ?? 0)) / 2;

    return Scaffold(
      appBar: AppBar(title: Text(cow['cowId'])),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 MAIN CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [getColor(cow['status']), Colors.black87],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    cow['cowId'],
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    cow['status'],
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Confidence: ${cow['mlConfidence']}%",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 DETAILS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("🌡 Temp: ${cow['temperature']}°C"),
                    Text("💧 Humidity: ${cow['humidity']}%"),
                    Text("🌬 Air Quality: ${air.toStringAsFixed(2)}"),
                    Text("🦠 Disease: ${cow['mlDisease']}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}