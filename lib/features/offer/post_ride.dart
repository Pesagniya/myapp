import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/radio.dart';
import 'package:myapp/core/widgets/textfield.dart';
import 'package:myapp/features/offer/geolocator_service.dart';

enum RideDirection { fromFatec, toFatec }

class PostRidesScreen extends StatefulWidget {
  const PostRidesScreen({super.key});

  @override
  State<PostRidesScreen> createState() => _PostRidesScreenState();
}

class _PostRidesScreenState extends State<PostRidesScreen> {
  final TextEditingController userLocationController = TextEditingController();
  final LocationService locationService = LocationService();

  RideDirection selectedDirection = RideDirection.toFatec;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isDepartureEditable = selectedDirection == RideDirection.toFatec;

    return Scaffold(
      appBar: AppBar(title: Text('Qual será o seu trajeto?')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 8),
        child: Column(
          children: [
            // Radio buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRadioButton<RideDirection>(
                  value: RideDirection.toFatec,
                  groupValue: selectedDirection,
                  onChanged: (val) => setState(() => selectedDirection = val),
                  label: 'Ir para Fatec',
                ),
                CustomRadioButton<RideDirection>(
                  value: RideDirection.fromFatec,
                  groupValue: selectedDirection,
                  onChanged: (val) => setState(() => selectedDirection = val),
                  label: 'Sair da Fatec',
                ),
              ],
            ),

            const SizedBox(height: 60),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: 40,
                  height: 115,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/traject.png'),
                      fit: BoxFit.contain,
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
                      if (isDepartureEditable)
                        MyTextField(
                          labelText: 'De:',
                          controller: userLocationController,
                        )
                      else
                        const MyTextField(
                          labelText: 'De: FATEC Sorocaba',
                          enabled: false,
                        ),

                      const SizedBox(height: 8),

                      // "Utilizar localização atual?" with loading indicator
                      if (isDepartureEditable)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: GestureDetector(
                            onTap:
                                isLoading
                                    ? null
                                    : () async {
                                      setState(() => isLoading = true);
                                      final address =
                                          await locationService
                                              .getCurrentAddress();
                                      setState(() => isLoading = false);
                                      if (address != null) {
                                        userLocationController.text = address;
                                      }
                                    },
                            child: Row(
                              children: [
                                const Text(
                                  'Utilizar localização atual?',
                                  style: TextStyle(fontSize: 10),
                                ),
                                const SizedBox(width: 5),
                                if (isLoading)
                                  const SizedBox(
                                    width: 10,
                                    height: 1,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      if (!isDepartureEditable)
                        MyTextField(
                          labelText: 'Para:',
                          controller: userLocationController,
                        )
                      else
                        const MyTextField(
                          labelText: 'Para: FATEC Sorocaba',
                          enabled: false,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/* without fixed textfield
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

  bool isLoading = false;

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
              width: 30,
              height: 135,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/traject.png'),
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

                  // "Utilizar localização atual?" com loading indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap:
                          isLoading
                              ? null
                              : () async {
                                setState(() => isLoading = true);
                                final address =
                                    await locationService.getCurrentAddress();
                                setState(() => isLoading = false);

                                if (address != null) {
                                  firstController.text = address;
                                }
                              },
                      child: Row(
                        children: [
                          Text(
                            'Utilizar localização atual?',
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 5),
                          if (isLoading)
                            const SizedBox(
                              width: 10,
                              height: 1,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              ),
                            ),
                        ],
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
*/