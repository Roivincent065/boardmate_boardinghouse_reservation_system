import 'package:flutter/material.dart';
import '../providers/data_provider.dart';
import '../widgets/room_card.dart';
import '../widgets/bottom_nav.dart';
import '../models/room.dart';

class BrowseRoomsScreen extends StatefulWidget {
  const BrowseRoomsScreen({super.key});

  @override
  State<BrowseRoomsScreen> createState() => _BrowseRoomsScreenState();
}

class _BrowseRoomsScreenState extends State<BrowseRoomsScreen> {
  int _currentIndex = 1;
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = DataProvider.fetchAvailableRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              right: 24,
              bottom: 16,
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Browse Rooms',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: double.infinity, height: 4),
                FutureBuilder<List<Room>>(
                  future: _roomsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading rooms...',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      );
                    }
                    final rooms = snapshot.data ?? [];
                    return Text(
                      '${rooms.length} rooms available',
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Room>>(
              future: _roomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load rooms right now.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                }

                final rooms = snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return RoomCard(
                      room: room,
                      onTap: () =>
                          Navigator.pushNamed(context, '/room/${room.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/student');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/matches');
              break;
            case 3:
              Navigator.pushNamed(context, '/chats');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
