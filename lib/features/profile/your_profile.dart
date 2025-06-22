import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/profile/profile_model.dart';
import 'package:myapp/features/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/button.dart';
import 'package:myapp/features/profile/dropdown.dart';
import 'package:myapp/core/widgets/textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Profile profile;
  final nameController = TextEditingController();
  final carroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _profileService.fetchUserProfile();
    if (data != null) {
      setState(() {
        profile = data;
        nameController.text = profile.name!;
        carroController.text = profile.carro!;
      });
    }
  }

  Future<void> pickImage() async {
    final newPhotoUrl = await _profileService.uploadProfilePhoto();
    if (newPhotoUrl != null) {
      setState(() {
        profile = profile.copyWith(photoUrl: newPhotoUrl);
      });
    }
  }

  Future<void> saveProfile() async {
    setState(() {
      profile = profile.copyWith(
        name: nameController.text,
        carro: carroController.text,
      );
    });

    await _profileService.saveProfile(profile);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Perfil salvo com sucesso!')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    carroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    profile.photoUrl != null
                        ? Image.network(
                          profile.photoUrl!,
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          'assets/images/default_pp.png',
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                // needed null protection here
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _auth.currentUser!.email!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),

            MyTextField(
              controller: nameController,
              labelText: 'Digite o seu nome',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            MyDropdown<String>(
              labelText: 'Selecione o seu curso',
              value: profile.curso ?? 'none',
              items: [
                DropdownMenuItem(
                  value: 'none',
                  child: Text('Não quero informar'),
                ),
                DropdownMenuItem(
                  value: 'ADS',
                  child: Text('Análise e Desenvolvimento de Sistemas'),
                ),
                DropdownMenuItem(
                  value: 'EA',
                  child: Text('Eletrônica Automotiva'),
                ),
                DropdownMenuItem(
                  value: 'GA',
                  child: Text('Gestão de Qualidade'),
                ),
                DropdownMenuItem(value: 'LG', child: Text('Logística')),
                DropdownMenuItem(
                  value: 'MA',
                  child: Text('Manufatura Avançada'),
                ),
                DropdownMenuItem(
                  value: 'MAE',
                  child: Text('Manutenção de Aeronaves'),
                ),
                DropdownMenuItem(value: 'PO', child: Text('Polímeros')),
                DropdownMenuItem(
                  value: 'PM',
                  child: Text('Processos Metalúrgicos'),
                ),
                DropdownMenuItem(
                  value: 'PMC',
                  child: Text('Processos Mecânicos'),
                ),
                DropdownMenuItem(
                  value: 'SB',
                  child: Text('Sistemas Biomédicos'),
                ),
              ],
              onChanged: (newValue) {
                setState(() {
                  profile = profile.copyWith(curso: newValue);
                });
              },
            ),

            MyTextField(
              controller: carroController,
              labelText: 'Informe a placa do seu carro (opcional)',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            MyButton(text: 'Salvar Alterações', onTap: saveProfile),
          ],
        ),
      ),
    );
  }
}
