import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  int _currentIndex = 4;
  final _schoolController = TextEditingController();
  final _budgetMinController = TextEditingController(text: '3000');
  final _budgetMaxController = TextEditingController(text: '6000');
  String _studyHabit = 'night';
  String _sleepSchedule = 'night-owl';
  bool _smoker = false;
  String _cleanliness = 'clean';
  List<String> _personality = [];

  final List<String> _traits = ['quiet', 'social', 'gamer', 'clean', 'messy'];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: double.infinity, height: 4),
                Text(
                  'Set up your lifestyle preferences',
                  style: TextStyle(color: Colors.white70),
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
                  // Avatar section
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
                            user?.name ?? 'Unknown',
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
                  // School
                  TextField(
                    controller: _schoolController,
                    decoration: const InputDecoration(
                      labelText: 'School / University',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Budget
                  const Text(
                    'Budget Range (₱)',
                    style: TextStyle(fontWeight: FontWeight.w500),
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
                  // Study Habits
                  const Text(
                    'Study Habits',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _studyHabit = 'morning'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _studyHabit == 'morning'
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _studyHabit == 'morning'
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '🌅 Early Morning',
                                style: TextStyle(
                                  color: _studyHabit == 'morning'
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _studyHabit = 'night'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _studyHabit == 'night'
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _studyHabit == 'night'
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '🌙 Late Night',
                                style: TextStyle(
                                  color: _studyHabit == 'night'
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sleep Schedule
                  const Text(
                    'Sleep Schedule',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _sleepSchedule = 'early'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _sleepSchedule == 'early'
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _sleepSchedule == 'early'
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '😴 Early Sleeper',
                                style: TextStyle(
                                  color: _sleepSchedule == 'early'
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _sleepSchedule = 'night-owl'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _sleepSchedule == 'night-owl'
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _sleepSchedule == 'night-owl'
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '🦉 Night Owl',
                                style: TextStyle(
                                  color: _sleepSchedule == 'night-owl'
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Smoking
                  const Text(
                    'Smoking',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _smoker = false),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _smoker == false
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _smoker == false
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '🚭 Non-smoker',
                                style: TextStyle(
                                  color: _smoker == false
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _smoker = true),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _smoker == true
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _smoker == true
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '🚬 Smoker',
                                style: TextStyle(
                                  color: _smoker == true
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Cleanliness
                  const Text(
                    'Cleanliness',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['clean', 'moderate', 'messy'].map((c) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _cleanliness = c),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _cleanliness == c
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                              ),
                              color: _cleanliness == c
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                c == 'clean'
                                    ? '✨'
                                    : c == 'moderate'
                                    ? '👍'
                                    : '🤷',
                                style: TextStyle(
                                  color: _cleanliness == c
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Personality
                  const Text(
                    'Personality Traits',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _traits.map((t) {
                      final selected = _personality.contains(t);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _personality.remove(t);
                            } else {
                              _personality.add(t);
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
                            t,
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
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile saved!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Profile'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await auth.logout();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.red,
                      ),
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
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/student');
              break;
            case 1:
              Navigator.pushNamed(context, '/browse');
              break;
            case 2:
              Navigator.pushNamed(context, '/matches');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/chats');
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }
}
