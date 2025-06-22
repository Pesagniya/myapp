import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/search/search_service.dart';
import 'package:myapp/core/widgets/button.dart';
import 'package:myapp/features/shared/ride_model.dart';

class RideDetails extends StatefulWidget {
  final RideData ride;

  const RideDetails({super.key, required this.ride});

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  final SearchService _searchService = SearchService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Dados da carona')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row traject - start, end
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/traject.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        ride.finish,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            dividerSpacing(),

            // Second row text - price value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Preço total',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'R\$ ${ride.price?.toStringAsFixed(2) ?? "-"}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            dividerSpacing(),

            // Third row profile photo, name - review value - chat
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        ride.photoURL ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        emailToName(ride.email),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Classificação média',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 60,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        print('Tapped arrow');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Chat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(66, 48, 45, 45),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            dividerSpacing(),

            // Fourth row car details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/car.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nome do carro',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Cor: '), Text('Vagas: ')],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Ano: '), Text('Placa: ')],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            MyButton(
              text: 'Registrar Reserva',
              onTap: () async {
                final success = await _searchService.applyToRide(
                  rideId: ride.rideId!,
                  userId: currentUserId,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Reserva registrada!' : 'Operação inválida.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dividerSpacing() {
    return Column(
      children: [
        SizedBox(height: 12),
        Divider(color: Colors.grey),
        SizedBox(height: 8),
      ],
    );
  }

  String emailToName(email) {
    // Standard fatec email is name.surname@ (with optional)
    // Extract before @
    final name = email.split('@')[0];

    return name
        .replaceAll(RegExp(r'\d+'), '') // Remove numbers
        .split('.')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
