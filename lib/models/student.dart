class Student {
  final String id;
  final String name;
  final String avatar;
  final String school;
  final int budgetMin;
  final int budgetMax;
  final String preferredLocation;
  final String moveInDate;
  final String studyHabit; // 'night' or 'morning'
  final List<String> personality;
  final bool smoker;
  final String sleepSchedule; // 'early' or 'night-owl'
  final String cleanliness; // 'clean', 'moderate', or 'messy'

  const Student({
    required this.id,
    required this.name,
    this.avatar = '',
    required this.school,
    required this.budgetMin,
    required this.budgetMax,
    required this.preferredLocation,
    required this.moveInDate,
    required this.studyHabit,
    required this.personality,
    required this.smoker,
    required this.sleepSchedule,
    required this.cleanliness,
  });
}
