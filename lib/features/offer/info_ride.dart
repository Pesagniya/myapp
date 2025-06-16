import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/button.dart';
import 'package:myapp/core/widgets/textfield.dart';
import 'package:myapp/features/offer/post_success.dart';
import 'package:myapp/features/offer/ride_service.dart';
import 'package:myapp/features/shared/ride_model.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoRide extends StatefulWidget {
  final RideData rideData;

  const InfoRide({super.key, required this.rideData});

  @override
  State<InfoRide> createState() => _InfoRideState();
}

class _InfoRideState extends State<InfoRide> {
  DateTime selectedDateTime = DateTime.now();
  final TextEditingController dateController = TextEditingController();

  int seatCount = 1;

  final RideService rideService = RideService();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

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

  void _incrementSeat() {
    setState(() {
      if (seatCount < 5) seatCount++;
    });
  }

  void _decrementSeat() {
    setState(() {
      if (seatCount > 1) seatCount--;
    });
  }

  Future<void> _onButtonPressed() async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final updatedRide = widget.rideData.copyWith(
      driverId: currentUserId,
      passengers: seatCount,
      departure: selectedDateTime,
    );

    try {
      await rideService.addRide(updatedRide);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PostSuccessPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar viagem: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informações da Viagem')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Text(
                'Quando você fará a viagem?',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            MyTextField(
              labelText: 'Data',
              controller: dateController,
              keyboardType: TextInputType.none,
              onTap: _chooseDateTime,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Text(
                'Qual o número de assentos no seu carro?',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  IconButton(
                    onPressed: seatCount > 1 ? _decrementSeat : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color:
                        seatCount > 1
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    iconSize: 30,
                  ),
                  Text(
                    seatCount.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: seatCount < 5 ? _incrementSeat : null,
                    icon: const Icon(Icons.add_circle_outline),
                    color:
                        seatCount < 5
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    iconSize: 30,
                  ),
                ],
              ),
            ),
            const Spacer(),
            MyButton(text: 'Continuar', onTap: _onButtonPressed),
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
}
