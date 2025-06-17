import 'dart:async';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/button.dart';
import 'package:myapp/core/widgets/radio.dart';
import 'package:myapp/core/widgets/textfield.dart';
import 'package:myapp/features/offer/geolocator_service.dart';
import 'package:myapp/features/offer/offer_info.dart';
import 'package:myapp/features/shared/ride_model.dart';

enum RideDirection { fromFatec, toFatec }

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  final TextEditingController userLocationController = TextEditingController();
  final LocationService locationService = LocationService();

  RideDirection selectedDirection = RideDirection.toFatec;
  bool isLoading = false;

  List<String> suggestions = [];
  Timer? _debounce;

  void onUserInput(String input) {
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
    setState(() {
      selectedDirection = val;
      userLocationController.clear();
    });
  }

  DateTime selectedDateTime = DateTime.now();
  final TextEditingController dateController = TextEditingController();
  Future<void> _chooseDateTime() async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: selectedDateTime,
      minimumDate: DateTime.now(),
      options: BoardDateTimeOptions(
        languages: BoardPickerLanguages(
          locale: 'pt_BR',
          today: 'Hoje',
          tomorrow: 'Amanhã',
          now: 'Agora',
        ),
        pickerFormat: PickerFormat.dmy,
        activeColor: Theme.of(context).colorScheme.primary,
        backgroundDecoration: const BoxDecoration(color: Colors.white),
      ),
    );

    if (result != null) {
      setState(() {
        selectedDateTime = result;
        dateController.text = _formatDateTime(result);
      });
    }
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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoRide(rideData: rideData)),
    );
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
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Ache sua carona'),
            const SizedBox(width: 8),
            const Icon(Icons.content_paste_search, size: 24),
          ],
        ),
      ),
      body: Padding(
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

            //input fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      MyTextField(
                        labelText: 'Data',
                        controller: dateController,
                        keyboardType: TextInputType.none,
                        onTap: _chooseDateTime,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),

            // map and next button
            const Spacer(),
            MyButton(text: 'Continuar', onTap: onButtonPressed),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
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
          },
        );
      },
    );
  }
}
