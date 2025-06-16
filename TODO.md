reenviar email na tela de signup,
usb
https://stackoverflow.com/questions/79102777/how-to-resolve-source-value-8-is-obsolete-warning-in-android-studio
stylize 2nd textfield variant
show offer only if car valid

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/button.dart';
import 'package:myapp/core/widgets/dropdown.dart';
import 'package:myapp/core/widgets/textfield.dart';

class ProfileScreen extends StatefulWidget {
const ProfileScreen({super.key});

@override
State<ProfileScreen> createState() => \_ProfileScreenState();
}

class \_ProfileScreenState extends State<ProfileScreen> {
final ProfileService \_profileService = ProfileService();
final FirebaseAuth \_auth = FirebaseAuth.instance;

String? name;
String? photoUrl;
String? selectedCurso;

final nameController = TextEditingController();
final carroController = TextEditingController();

@override
void initState() {
super.initState();
\_loadUserData();
}

Future<void> \_loadUserData() async {
final data = await \_profileService.fetchUserData();
if (data != null) {
setState(() {
nameController.text = data['name'] ?? '';
selectedCurso = data['curso'];
carroController.text = data['carro'] ?? '';
photoUrl = data['photoUrl'];
});
}
}

Future<void> pickImage() async {
final imageFile = await \_profileService.pickAndUploadImage(
\_auth.currentUser!.uid,
);
if (imageFile != null) {
setState(() => photoUrl = imageFile);
}
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
photoUrl != null
? Image.network(
photoUrl!,
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
\_auth.currentUser!.email!,
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
              value: selectedCurso ?? 'none',
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
                  selectedCurso = newValue;
                });
              },
            ),

            MyTextField(
              controller: carroController,
              labelText: 'Informe a placa do seu carro (opcional)',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            MyButton(
              text: 'Salvar Alterações',
              onTap: () {
                _profileService.saveUserData(
                  uid: _auth.currentUser!.uid,
                  name: nameController.text,
                  curso: selectedCurso,
                  carro: carroController.text,
                  photoUrl: photoUrl,
                ); // Save logic would be handled by ProfileService
              },
            ),
          ],
        ),
      ),
    );

}
}
