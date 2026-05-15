import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class PostRoomScreen extends StatefulWidget {
  const PostRoomScreen({super.key});

  @override
  State<PostRoomScreen> createState() => _PostRoomScreenState();
}

class _PostRoomScreenState extends State<PostRoomScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  List<String> _selectedAmenities = [];

  final List<String> _amenityOptions = [
    'WiFi',
    'Aircon',
    'Bed',
    'Desk',
    'Private CR',
    'Shared CR',
    'Kitchen',
    'Laundry',
    'Parking',
  ];

  int _currentIndex = 1;

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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Post New Room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Room Title',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Cozy room near UP',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Price & Deposit
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Monthly Rent (₱)',
                            border: OutlineInputBorder(),
                            hintText: '4500',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _depositController,
                          decoration: const InputDecoration(
                            labelText: 'Deposit (₱)',
                            border: OutlineInputBorder(),
                            hintText: '4500',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Address
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      hintText: 'Full address',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Capacity
                  TextField(
                    controller: _capacityController,
                    decoration: const InputDecoration(
                      labelText: 'Room Capacity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      hintText: 'Describe your room...',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // Amenities
                  const Text(
                    'Amenities',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _amenityOptions.map((amenity) {
                      final selected = _selectedAmenities.contains(amenity);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedAmenities.remove(amenity);
                            } else {
                              _selectedAmenities.add(amenity);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300]!,
                            ),
                            color: selected
                                ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1)
                                : null,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              color: selected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Room posted!')),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Publish Listing'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        isLandlord: true,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/landlord');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, '/my-listings');
              break;
            case 3:
              Navigator.pushNamed(context, '/chats');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
