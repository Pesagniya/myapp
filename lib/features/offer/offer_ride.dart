import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/widgets/textfield.dart';
import 'package:myapp/features/shared/geolocator_service.dart';
import 'package:myapp/features/offer/offer_rideinfo.dart';
import 'package:myapp/features/offer/w_map.dart';
import 'package:myapp/features/offer/w_next.dart';
import 'package:myapp/features/shared/ride_model.dart';
import 'package:myapp/features/shared/w_radio.dart';

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

  List<String> suggestions = [];
  Timer? _debounce;

  // Default (FATEC Sorocaba)
  LatLng mapCenter = LatLng(-23.4827, -47.4260);

  void onUserInput(String input) {
    // Adds timer to http call for address
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (input.isNotEmpty) {
        final results = await locationService.getAddressSuggestions(input);
        setState(() => suggestions = results);
      } else {
        setState(() => suggestions = []);
      }
    });
  }

  void handleDirectionChange(RideDirection val) {
    // Clear controller onchange
    setState(() {
      selectedDirection = val;
      userLocationController.clear();
    });
  }

  void onButtonPressed() {
    if (userLocationController.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Endereço não informado'),
              content: const Text(
                'Por favor, insira sua localização antes de continuar.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    final rideData = RideData(
      start:
          selectedDirection == RideDirection.toFatec
              ? userLocationController.text
              : "FATEC Sorocaba",
      finish:
          selectedDirection == RideDirection.toFatec
              ? "FATEC Sorocaba"
              : userLocationController.text,
    );

    // Pass start and end to next page offer_info
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoRide(rideData: rideData)),
    );
  }

  Future<void> drawRoute() async {
    // TODO : show route
  }

  @override
  void dispose() {
    _debounce?.cancel();
    userLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qual será o seu trajeto?')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              // Radio buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomRadioButton<RideDirection>(
                    value: RideDirection.toFatec,
                    groupValue: selectedDirection,
                    onChanged: handleDirectionChange,
                    label: 'Ir para Fatec',
                  ),
                  CustomRadioButton<RideDirection>(
                    value: RideDirection.fromFatec,
                    groupValue: selectedDirection,
                    onChanged: handleDirectionChange,
                    label: 'Sair da Fatec',
                  ),
                ],
              ),

              const SizedBox(height: 70),

              // Traject asset image and input fields
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 8),
                    width: 30,
                    height: 115,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/traject.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDepartureField(),
                        const SizedBox(height: 8),
                        if (selectedDirection == RideDirection.toFatec)
                          _buildUseLocationButton(),
                        const SizedBox(height: 20),
                        _buildArrivalField(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              // Map and next button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 420,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Stack(
                        children: [
                          SelectableMap(
                            center: mapCenter,
                            onTap: (point) async {
                              setState(() {
                                mapCenter = point;
                              });
                              // Changes controller text to point in map
                              userLocationController.text =
                                  (await locationService
                                      .getAddressFromCoordinates(
                                        point.latitude,
                                        point.longitude,
                                      ))!;
                            },
                          ),
                          Positioned(
                            right: 8,
                            child: NextButton(
                              onPressed: () {
                                onButtonPressed();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartureField() {
    if (selectedDirection == RideDirection.toFatec) {
      return Column(
        children: [
          MyTextField(
            controller: userLocationController,
            onChanged: onUserInput,
            labelText: 'De:',
          ),
          _buildSuggestionList(),
        ],
      );
    } else {
      return const MyTextField(labelText: 'De: FATEC Sorocaba', enabled: false);
    }
  }

  Widget _buildArrivalField() {
    if (selectedDirection == RideDirection.fromFatec) {
      return Column(
        children: [
          MyTextField(
            controller: userLocationController,
            onChanged: onUserInput,
            labelText: 'Para:',
          ),
          _buildSuggestionList(),
        ],
      );
    } else {
      return const MyTextField(
        labelText: 'Para: FATEC Sorocaba',
        enabled: false,
      );
    }
  }

  Widget _buildUseLocationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap:
            isLoading
                ? null
                : () async {
                  setState(() => isLoading = true);

                  final position =
                      await locationService.getCurrentCoordinates();

                  setState(() => isLoading = false);

                  if (position != null) {
                    final address = await locationService
                        .getAddressFromCoordinates(
                          position.latitude,
                          position.longitude,
                        );

                    if (address != null) {
                      userLocationController.text = address;
                    }

                    setState(() {
                      mapCenter = LatLng(position.latitude, position.longitude);
                    });
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
                height: 10,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () async {
            final selectedAddress = suggestions[index];
            userLocationController.text = selectedAddress;
            setState(() => suggestions = []);

            final coords = await locationService.getCoordinatesFromAddress(
              selectedAddress,
            );
            // Changes map center to chosen address from list
            if (coords != null) {
              setState(() {
                mapCenter = coords;
              });
            }
          },
        );
      },
    );
  }
}
