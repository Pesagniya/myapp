import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/widgets/textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  String? userEmail;
  String? photoUrl;

  final nameController = TextEditingController();
  final cursoController = TextEditingController();
  final carroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = doc.data();

    setState(() {
      userEmail = user.email;
      nameController.text = data?['name'] ?? '';
      cursoController.text = data?['curso'] ?? '';
      carroController.text = data?['carro'] ?? '';
      photoUrl = data?['photoUrl'];
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImage(File imageFile, String uid) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos')
        .child('$uid.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? uploadedPhotoUrl = photoUrl;
    if (_image != null) {
      uploadedPhotoUrl = await uploadImage(_image!, user.uid);
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'name': nameController.text.trim(),
      'curso': cursoController.text.trim(),
      'carro': carroController.text.trim(),
      'photoUrl': uploadedPhotoUrl,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil atualizado com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _image != null
                        ? FileImage(_image!)
                        : (photoUrl != null
                            ? NetworkImage(photoUrl!) as ImageProvider
                            : null),
                child:
                    _image == null && photoUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userEmail ?? 'Carregando...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),

            // Editable name field
            MyTextField(hintText: 'Nome', controller: nameController),
            const SizedBox(height: 10),

            // Curso
            MyTextField(hintText: 'Curso', controller: cursoController),
            const SizedBox(height: 10),

            // Carro
            MyTextField(hintText: 'Carro', controller: carroController),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
