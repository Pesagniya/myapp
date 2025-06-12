import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/textfield.dart';
import 'package:myapp/features/offer/geolocator_service.dart';

class PostRidesScreen extends StatefulWidget {
  PostRidesScreen({super.key});

  @override
  State<PostRidesScreen> createState() => _PostRidesScreenState();
}

class _PostRidesScreenState extends State<PostRidesScreen> {
  final TextEditingController firstController = TextEditingController();
  final LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qual será o seu trajeto?')),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('images/traject.png'),
                ),
              ),
            ),
            const SizedBox(width: 3),

            // Text Fields
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(labelText: 'De:', controller: firstController),
                  const SizedBox(height: 8),

                  // "Utilizar localização atual?" as a button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () async {
                        final address = await LocationService()
                            .selectLocationFromMap(context);
                        if (address != null) {
                          firstController.text = address;
                          // Use the address
                        }
                      },
                      child: Text(
                        'Utilizar localização atual?',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  MyTextField(
                    labelText: 'Para: FATEC Sorocaba',
                    enabled: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
