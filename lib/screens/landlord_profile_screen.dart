import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/bottom_nav.dart';

class LandlordProfileScreen extends StatefulWidget {
  const LandlordProfileScreen({super.key});

  @override
  State<LandlordProfileScreen> createState() => _LandlordProfileScreenState();
}

class _LandlordProfileScreenState extends State<LandlordProfileScreen> {
  int _currentIndex = 4;

  final _budgetMinController = TextEditingController(text: '8000');
  final _budgetMaxController = TextEditingController(text: '18000');
  final _notesController = TextEditingController();

  String _tenantGender = 'No preference';
  String _leaseTerm = '6 months';
  String _cleanliness = 'Average';
  bool _petsAllowed = true;
  bool _smokingAllowed = false;

  final List<String> _genderOptions = [
    'No preference',
    'Male',
    'Female',
    'Couples',
  ];

  final List<String> _leaseOptions = [
    '3 months',
    '6 months',
    '12 months',
    'Flexible',
  ];

  final List<String> _cleanlinessOptions = ['Relaxed', 'Average', 'Very clean'];

  @override
  void dispose() {
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSignOut() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: double.infinity, height: 4),
                  Text(
                    'Set the ideal tenant profile and rental policies',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Landlord',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Rent Range (₱)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _budgetMinController,
                          decoration: const InputDecoration(
                            labelText: 'Min',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _budgetMaxController,
                          decoration: const InputDecoration(
                            labelText: 'Max',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Preferred Tenant Gender',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _tenantGender,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _genderOptions
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _tenantGender = value);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Lease Term',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _leaseTerm,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _leaseOptions
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _leaseTerm = value);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Cleanliness Expectation',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _cleanliness,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _cleanlinessOptions
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _cleanliness = value);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text('Pets Allowed'),
                    subtitle: const Text(
                      'Allow tenants to keep pets on the property',
                    ),
                    value: _petsAllowed,
                    onChanged: (value) => setState(() => _petsAllowed = value),
                  ),

                  SwitchListTile(
                    title: const Text('Smoking Allowed'),
                    subtitle: const Text(
                      'Allow smoking inside the rental unit',
                    ),
                    value: _smokingAllowed,
                    onChanged: (value) =>
                        setState(() => _smokingAllowed = value),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Additional Notes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Describe your ideal tenant or house rules',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Preferences saved!')),
                        );
                      },
                      child: const Text('Save Preferences'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _handleSignOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
              Navigator.pushReplacementNamed(context, '/post-room');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/my-listings');
              break;
            case 3:
              Navigator.pushNamed(context, '/chats');
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }
}
