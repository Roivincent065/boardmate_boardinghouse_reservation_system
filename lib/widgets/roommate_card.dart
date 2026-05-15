import 'package:flutter/material.dart';
import '../models/student.dart';

class RoommateCard extends StatelessWidget {
  final Student student;
  final int compatibility;

  const RoommateCard({
    super.key,
    required this.student,
    required this.compatibility,
  });

  String get matchLevel {
    if (compatibility >= 80) return 'high';
    if (compatibility >= 60) return 'medium';
    return 'low';
  }

  Color get matchColor {
    if (matchLevel == 'high') return Colors.green;
    if (matchLevel == 'medium') return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final avatarRadius = width < 360 ? 20.0 : (width < 520 ? 24.0 : 28.0);
        final nameFontSize = width < 360 ? 14.0 : 16.0;
        final schoolFontSize = width < 360 ? 12.0 : 14.0;
        final matchFontSize = width < 360 ? 11.0 : 12.0;
        final pillPadding = EdgeInsets.symmetric(
          horizontal: width < 360 ? 8 : 10,
          vertical: 4,
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(width < 360 ? 12 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    student.name.isNotEmpty
                        ? student.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: avatarRadius * 0.9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(width: width < 360 ? 10 : 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              student.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: nameFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: pillPadding,
                            decoration: BoxDecoration(
                              color: matchColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$compatibility% match',
                              style: TextStyle(
                                fontSize: matchFontSize,
                                fontWeight: FontWeight.bold,
                                color: matchColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width < 360 ? 4 : 6),
                      Text(
                        student.school,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: schoolFontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: width < 360 ? 8 : 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _buildTag(
                            student.sleepSchedule == 'night-owl'
                                ? '🌙 Night Owl'
                                : '🌅 Early Bird',
                          ),
                          _buildTag(
                            student.studyHabit == 'night'
                                ? 'Studies late'
                                : 'Studies early',
                          ),
                          _buildTag(student.cleanliness),
                        ],
                      ),
                      SizedBox(height: width < 360 ? 8 : 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: student.personality.map((trait) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width < 360 ? 6 : 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              trait,
                              style: TextStyle(fontSize: width < 360 ? 11 : 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }
}
