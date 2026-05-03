import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final majorController = TextEditingController();
  final bioController = TextEditingController();
  final coursesController = TextEditingController();
  final availabilityController = TextEditingController();
  final interestsController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      majorController.text = data['major'] ?? '';
      bioController.text = data['bio'] ?? '';
      coursesController.text = data['courses'] ?? '';
      availabilityController.text = data['availability'] ?? '';
      interestsController.text = data['interests'] ?? '';
    }

    setState(() => isLoading = false);
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': nameController.text.trim(),
      'major': majorController.text.trim(),
      'bio': bioController.text.trim(),
      'courses': coursesController.text.trim(),
      'availability': availabilityController.text.trim(),
      'interests': interestsController.text.trim(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget buildField(TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildField(nameController, "Name", Icons.person),
                  buildField(majorController, "Major", Icons.school),
                  buildField(bioController, "Bio", Icons.info),
                  buildField(coursesController, "Courses", Icons.book),
                  buildField(availabilityController, "Availability", Icons.access_time),
                  buildField(interestsController, "Interests", Icons.favorite),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: saveProfile,
                    child: const Text("Save Changes"),
                  )
                ],
              ),
            ),
    );
  }
}