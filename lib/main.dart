import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

///////////////////////
// SPLASH
///////////////////////

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/logo.png", width: 200)),
    );
  }
}

///////////////////////
// HOME
///////////////////////

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> familyContacts = [];
  final ref = FirebaseDatabase.instance.ref("alert");

  @override
  void initState() {
    super.initState();
    loadContacts();
    listenToFirebase();
  }

  Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("contacts");

    if (data != null) {
      List decoded = jsonDecode(data);
      setState(() {
        familyContacts = decoded
            .map((e) => Map<String, String>.from(e))
            .toList();
      });
    }
  }

  void listenToFirebase() {
    ref.onValue.listen((event) async {
      final value = event.snapshot.value?.toString();

      if (value != null && value != "NONE") {
        await sendSOS();
        await ref.set("NONE");
      }
    });
  }

  ///////////////////////
  // ✅ UPDATED SOS
  ///////////////////////

  Future<void> sendSOS() async {
    if (familyContacts.isEmpty) return;

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String link = "https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
    String msg = "🚨 EMERGENCY! I need help. Location: $link";

    // 📞 CALL FIRST 2 CONTACTS
    for (int i = 0; i < familyContacts.length && i < 2; i++) {
      await FlutterPhoneDirectCaller.callNumber(familyContacts[i]["phone"]!);

      await Future.delayed(const Duration(seconds: 10)); // ✅ 10 sec gap
    }

    // 📩 SEND SMS (NO EXTRA DELAY)
    String numbers = familyContacts.map((c) => c["phone"]).join(";");
    await launchUrl(Uri.parse("sms:$numbers?body=$msg"));
  }

  Widget buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/bg.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.6)),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Be Safe",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: sendSOS,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 25,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  buildOption(
                    icon: Icons.family_restroom,
                    text: "Family Contacts",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmergencyContactsPage(familyContacts),
                        ),
                      );
                      await loadContacts();
                    },
                  ),

                  const SizedBox(height: 20),

                  buildOption(
                    icon: Icons.local_police,
                    text: "Emergency Contacts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmergencyNumbersPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////
// 🚨 EMERGENCY NUMBERS
///////////////////////

class EmergencyNumbersPage extends StatelessWidget {
  const EmergencyNumbersPage({super.key});

  Widget buildTile(String title, String number) {
    return ListTile(
      title: Text(title),
      trailing: Text(number),
      onTap: () {
        FlutterPhoneDirectCaller.callNumber(number); // ✅ CALL ADDED
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Numbers")),
      body: ListView(
        children: [
          buildTile("Police", "100"),
          buildTile("Fire", "101"),
          buildTile("Ambulance", "108"),
          buildTile("Women Helpline", "1091"),
          buildTile("Emergency", "112"),
        ],
      ),
    );
  }
}

///////////////////////
// CONTACT PAGE (UNCHANGED)
///////////////////////

class EmergencyContactsPage extends StatefulWidget {
  final List<Map<String, String>> familyContacts;
  const EmergencyContactsPage(this.familyContacts, {super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<Map<String, String>> contacts = [];
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("contacts");

    if (data != null) {
      List decoded = jsonDecode(data);
      setState(() {
        contacts = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("contacts", jsonEncode(contacts));
  }

  void showAddDialog() {
    // ✅ CLEAR OLD DATA FIRST
    nameController.clear();
    phoneController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              contacts.add({
                "name": nameController.text,
                "phone": phoneController.text,
              });

              await saveContacts();

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: ListView(
        children: [
          ...contacts.asMap().entries.map((entry) {
            int index = entry.key;
            var c = entry.value;

            return ListTile(
              title: Text(c["name"]!),
              subtitle: Text(c["phone"]!),
              onTap: () {
                nameController.text = c["name"]!;
                phoneController.text = c["phone"]!;

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Edit Contact"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(controller: nameController),
                        TextField(controller: phoneController),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          contacts[index] = {
                            "name": nameController.text,
                            "phone": phoneController.text,
                          };
                          await saveContacts();
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text("Update"),
                      ),
                    ],
                  ),
                );
              },
              onLongPress: () async {
                contacts.removeAt(index);
                await saveContacts();
                setState(() {});
              },
            );
          }),
          ListTile(title: const Text("Add Contact"), onTap: showAddDialog),
        ],
      ),
    );
  }
}
