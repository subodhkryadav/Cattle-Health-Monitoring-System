import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  String t(String en, String hi) => hi; // Hindi default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t("Stats", "आंकड़े"))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cows').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var cows = snapshot.data!.docs;

          int total = cows.length;
          int emergency = cows.where((c) => c['status'] == "Emergency").length;
          int critical = cows.where((c) => c['status'] == "Critical").length;
          int normal = cows.where((c) => c['status'] == "Normal").length;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(child: ListTile(title: Text("🐄 ${t("Total Cows", "कुल गाय")}: $total"))),
                Card(child: ListTile(title: Text("🔴 ${t("Emergency", "आपातकाल")}: $emergency"))),
                Card(child: ListTile(title: Text("🟠 ${t("Critical", "गंभीर")}: $critical"))),
                Card(child: ListTile(title: Text("🟢 ${t("Normal", "सामान्य")}: $normal"))),
              ],
            ),
          );
        },
      ),
    );
  }
}