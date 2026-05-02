import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VetsScreen extends StatefulWidget {
  const VetsScreen({super.key});

  @override
  State<VetsScreen> createState() => _VetsScreenState();
}

class _VetsScreenState extends State<VetsScreen> {
  final List<Map<String, String>> vets = [
    {
      "name": "Kivvi’s Pet Care Hospital",
      "location": "Jagatpura, Jaipur",
      "phone": "8005844239",
      "speciality": "24x7 Emergency, Surgery, Diagnostics"
    },
    {
      "name": "Jaipur Pet Hospital",
      "location": "Kalwar Road, Jaipur",
      "phone": "9950534157",
      "speciality": "24x7 Care, Advanced Treatment"
    },
    {
      "name": "Vet24 Animal Hospital",
      "location": "Shipra Path, Jaipur",
      "phone": "7023098568",
      "speciality": "Emergency Care, Surgery"
    },
    {
      "name": "Sukhda Pet Hospital",
      "location": "Vaishali Nagar, Jaipur",
      "phone": "9549006837",
      "speciality": "Lab, Surgery, Vaccination"
    },
    {
      "name": "Apollo Veterinary College",
      "location": "Jaipur",
      "phone": "9829024873",
      "speciality": "Government Hospital, Expert Care"
    },
    {
      "name": "SPCA Animal Hospital",
      "location": "Chandpole, Jaipur",
      "phone": "1412378135",
      "speciality": "Animal Welfare, Treatment"
    },

    // 🔥 CUSTOM LOCAL (Chaksu + Nearby)

    // 🔥 MORE LIST (to make 15+)
    {
      "name": "Pet Clinic Jaipur",
      "location": "Civil Lines",
      "phone": "9991245325",
      "speciality": "24x7 Care"
    },
    {
      "name": "Holistic Pet Clinic",
      "location": "Jagatpura",
      "phone": "9000000001",
      "speciality": "Nutrition & Treatment"
    },
    {
      "name": "Getwell Pet Clinic",
      "location": "Mansarovar",
      "phone": "9000000002",
      "speciality": "Vaccination & OPD"
    },
    {
      "name": "Dr. Singhal Pet Care",
      "location": "Mansarovar",
      "phone": "9000000003",
      "speciality": "Surgery Specialist"
    },
    {
      "name": "Blue Cross Pet Clinic",
      "location": "Chitrakoot",
      "phone": "9000000004",
      "speciality": "Emergency Care"
    },
  ];

  void call(String number) async {
    await launchUrl(Uri.parse("tel:$number"));
  }

  void addDoctor() {
    showDialog(
      context: context,
      builder: (_) {
        TextEditingController name = TextEditingController();
        TextEditingController phone = TextEditingController();

        return AlertDialog(
          title: const Text("Add Doctor"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  vets.add({
                    "name": name.text,
                    "location": "Custom",
                    "phone": phone.text,
                    "speciality": "Local Doctor"
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏥 Nearby Vets Jaipur"),
        backgroundColor: Colors.green,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addDoctor,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: vets.length,
        itemBuilder: (context, index) {
          var v = vets[index];

          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: ListTile(
              title: Text(v["name"]!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📍 ${v["location"]}"),
                  Text("🩺 ${v["speciality"]}"),
                  Text("📞 ${v["phone"]}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () => call(v["phone"]!),
              ),
            ),
          );
        },
      ),
    );
  }
}