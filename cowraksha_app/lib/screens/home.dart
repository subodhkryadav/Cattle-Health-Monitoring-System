import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/lang.dart';
import 'detail.dart';
import 'vets.dart';
import 'diseases.dart';
import 'chatbot.dart'; // 👈 IMPORTANT

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color getColor(String s) {
    if (s == "Emergency") return Colors.red;
    if (s == "Critical") return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🐄 CowRaksha AI"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              isHindi = !isHindi;
              (context as Element).markNeedsBuild();
            },
          )
        ],
      ),

      // 🔥 DRAWER
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text("Menu",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: Text(t("Cows", "गाय")),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: Text(t("Nearby Vets", "डॉक्टर")),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VetsScreen()),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.medical_services),
              title: Text(t("Diseases", "बीमारियां")),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiseasesScreen()),
              ),
            ),
          ],
        ),
      ),

      // 🔥 CHATBOT BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },
      ),

      // 🔥 FIREBASE DATA
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cows').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var cows = snapshot.data!.docs;

          int total = cows.length;
          int e = cows.where((c) => c['status'] == "Emergency").length;
          int c = cows.where((c) => c['status'] == "Critical").length;
          int n = cows.where((c) => c['status'] == "Normal").length;

          double temp = 0, hum = 0, co = 0, am = 0;

          for (var cow in cows) {
            var d = cow.data() as Map<String, dynamic>;
            temp += (d['temperature'] ?? 0);
            hum += (d['humidity'] ?? 0);
            co += (d['co'] ?? 0);
            am += (d['ammonia'] ?? 0);
          }

          if (total > 0) {
            temp /= total;
            hum /= total;
            co /= total;
            am /= total;
          }

          double air = (co + am) / 2;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [

              // 🔥 EMERGENCY ALERT
              if (e > 0)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "⚠ Emergency cows detected!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              // 🔥 PREMIUM DASHBOARD
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetric(Icons.thermostat, temp, "Temp", "तापमान"),
                    _buildMetric(Icons.water_drop, hum, "Humidity", "आर्द्रता"),
                    _buildMetric(Icons.air, air, "Air", "हवा"),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 🔥 STATS CARDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard("Total", total, Colors.blue),
                  _statCard("Emergency", e, Colors.red),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard("Critical", c, Colors.orange),
                  _statCard("Normal", n, Colors.green),
                ],
              ),

              const SizedBox(height: 15),

              // 🔥 COW LIST
              ...cows.map((doc) {
                var cow = doc.data() as Map<String, dynamic>;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Text(cow['cowId'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "${cow['mlDisease']} (${cow['mlConfidence']}%)"),
                    trailing: Chip(
                      label: Text(cow['status']),
                      backgroundColor: getColor(cow['status']),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CowDetailScreen(cow: cow),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  // 🔥 UI HELPERS
  Widget _buildMetric(IconData icon, double value, String en, String hi) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 30),
        Text(value.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        Text(t(en, hi), style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _statCard(String title, int value, Color color) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(5),
        child: ListTile(
          title: Text(title),
          trailing: Text(
            value.toString(),
            style: TextStyle(color: color, fontSize: 18),
          ),
        ),
      ),
    );
  }
}