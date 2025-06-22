import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/search/ride_details.dart';
import 'package:myapp/features/search/search_service.dart';
import 'package:myapp/features/search/ride_tile.dart';
import 'package:myapp/features/shared/ride_model.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final SearchService _searchService = SearchService();

  String? _filter;
  int _rideCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(40),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // Title
                  Expanded(
                    child: Center(
                      child: Text(
                        'Caronas encontradas: $_rideCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // Filter icon
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onSelected: (value) {
                      setState(() {
                        _filter = value;
                      });
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'price_low',
                            child: Text('Preço: Menor Preço'),
                          ),
                          const PopupMenuItem(
                            value: 'price_high',
                            child: Text('Preço: Maior Preço'),
                          ),
                          const PopupMenuItem(
                            value: 'departure_soon',
                            child: Text('Partindo em breve'),
                          ),
                        ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(child: _buildSearchList()),
        ],
      ),
    );
  }

  Widget _buildSearchList() {
    // Shows rides with optional filters
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _searchService.getRides(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var rides = snapshot.data!;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          rides =
              rides.where((ride) {
                final departure = ride['departureDateTime']?.toDate();

                // Check if ride is today or in the future
                final isUpcoming =
                    departure != null && !departure.isBefore(today);

                // Check if ride is not full
                final hasRoom = (ride['seats'] as int) > 0;

                return isUpcoming && hasRoom;
              }).toList();

          if (_rideCount != rides.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _rideCount = rides.length;
              });
            });
          }

          if (rides.isEmpty) {
            return const Center(
              child: Text(':(', style: TextStyle(fontSize: 20)),
            );
          }

          if (_filter == 'price_low') {
            rides.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
          } else if (_filter == 'price_high') {
            rides.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
          } else if (_filter == 'departure_soon') {
            rides.sort((a, b) {
              final d1 =
                  (a['departureDateTime'] as Timestamp?)?.toDate() ??
                  DateTime.now();
              final d2 =
                  (b['departureDateTime'] as Timestamp?)?.toDate() ??
                  DateTime.now();
              return d1.compareTo(d2);
            });
          }

          return ListView(
            children:
                rides.map((rideData) {
                  final ride = RideData.fromMap(rideData);
                  return Column(
                    children: [
                      _buildRideListItem(ride, context),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRideListItem(RideData ride, BuildContext context) {
    return RideTile(
      email: ride.email!,
      photoURL: ride.photoURL!,
      start: ride.start,
      finish: ride.finish,
      departure: ride.departure!,
      price: ride.price!,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RideDetails(ride: ride)),
        );
      },
    );
  }
}
