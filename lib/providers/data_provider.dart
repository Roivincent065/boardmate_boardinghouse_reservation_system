import '../models/student.dart';
import '../models/room.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';

class DataProvider {
  static final List<Student> mockStudents = [
    const Student(
      id: 's1',
      name: 'Maria Santos',
      school: 'UP Diliman',
      budgetMin: 3000,
      budgetMax: 5000,
      preferredLocation: 'Katipunan',
      moveInDate: '2026-03-01',
      studyHabit: 'night',
      personality: ['quiet', 'clean'],
      smoker: false,
      sleepSchedule: 'night-owl',
      cleanliness: 'clean',
    ),
    const Student(
      id: 's2',
      name: 'Anna Cruz',
      school: 'Ateneo de Manila',
      budgetMin: 4000,
      budgetMax: 6000,
      preferredLocation: 'Katipunan',
      moveInDate: '2026-03-15',
      studyHabit: 'night',
      personality: ['social', 'clean'],
      smoker: false,
      sleepSchedule: 'night-owl',
      cleanliness: 'clean',
    ),
    const Student(
      id: 's3',
      name: 'Jake Reyes',
      school: 'UP Diliman',
      budgetMin: 2500,
      budgetMax: 4500,
      preferredLocation: 'Philcoa',
      moveInDate: '2026-04-01',
      studyHabit: 'morning',
      personality: ['gamer', 'social'],
      smoker: false,
      sleepSchedule: 'early',
      cleanliness: 'moderate',
    ),
    const Student(
      id: 's4',
      name: 'Liza Mendoza',
      school: 'UST',
      budgetMin: 3500,
      budgetMax: 5500,
      preferredLocation: 'Sampaloc',
      moveInDate: '2026-03-01',
      studyHabit: 'night',
      personality: ['quiet'],
      smoker: false,
      sleepSchedule: 'night-owl',
      cleanliness: 'clean',
    ),
    const Student(
      id: 's5',
      name: 'Carlos Garcia',
      school: 'Ateneo de Manila',
      budgetMin: 4000,
      budgetMax: 7000,
      preferredLocation: 'Katipunan',
      moveInDate: '2026-03-01',
      studyHabit: 'morning',
      personality: ['clean', 'quiet'],
      smoker: false,
      sleepSchedule: 'early',
      cleanliness: 'clean',
    ),
  ];

  static final List<Room> mockRooms = [
    const Room(
      id: 'r1',
      landlordId: 'l1',
      title: 'Cozy Room near UP Diliman',
      price: 4500,
      deposit: 4500,
      address: '123 Katipunan Ave, QC',
      location: 'Katipunan',
      capacity: 2,
      currentOccupants: 1,
      amenities: ['WiFi', 'Bed', 'Desk', 'Shared CR'],
      photos: [],
      availability: 'available',
      description:
          'A cozy and well-ventilated room perfect for students. Walking distance to UP Diliman and Ateneo. Quiet neighborhood with easy access to food and transport.',
      landlordName: 'Mrs. Dela Cruz',
      landlordPhone: '+63 917 123 4567',
    ),
    const Room(
      id: 'r2',
      landlordId: 'l1',
      title: 'Spacious Room with Aircon',
      price: 6000,
      deposit: 6000,
      address: '456 Aurora Blvd, QC',
      location: 'Katipunan',
      capacity: 3,
      currentOccupants: 1,
      amenities: ['WiFi', 'Aircon', 'Bed', 'Private CR', 'Kitchen'],
      photos: [],
      availability: 'available',
      description:
          'Spacious airconditioned room with private comfort room. Includes access to shared kitchen. Near malls and restaurants.',
      landlordName: 'Mrs. Dela Cruz',
      landlordPhone: '+63 917 123 4567',
    ),
    const Room(
      id: 'r3',
      landlordId: 'l2',
      title: 'Budget Friendly Room in Sampaloc',
      price: 3000,
      deposit: 3000,
      address: '789 España Blvd, Manila',
      location: 'Sampaloc',
      capacity: 2,
      currentOccupants: 0,
      amenities: ['WiFi', 'Bed', 'Shared CR'],
      photos: [],
      availability: 'available',
      description:
          'Affordable room near UST and other universities in the University Belt. Basic amenities included. Perfect for students on a budget.',
      landlordName: 'Mr. Tan',
      landlordPhone: '+63 918 765 4321',
    ),
    const Room(
      id: 'r4',
      landlordId: 'l2',
      title: 'Premium Studio near Ateneo',
      price: 8000,
      deposit: 16000,
      address: '321 Xavierville Ave, QC',
      location: 'Katipunan',
      capacity: 1,
      currentOccupants: 0,
      amenities: [
        'WiFi',
        'Aircon',
        'Private CR',
        'Kitchen',
        'Parking',
        'Laundry',
      ],
      photos: [],
      availability: 'available',
      description:
          'Fully furnished premium studio unit. Includes all utilities. Exclusive and quiet neighborhood. 5-minute walk to Ateneo de Manila.',
      landlordName: 'Mr. Tan',
      landlordPhone: '+63 918 765 4321',
    ),
    const Room(
      id: 'r5',
      landlordId: 'l1',
      title: 'Shared Room near Philcoa',
      price: 2500,
      deposit: 2500,
      address: '555 Commonwealth Ave, QC',
      location: 'Philcoa',
      capacity: 4,
      currentOccupants: 2,
      amenities: ['WiFi', 'Bed', 'Shared CR', 'Laundry'],
      photos: [],
      availability: 'available',
      description:
          'Affordable shared room in a friendly boarding house. Close to UP Diliman and jeepney routes. Great community of student tenants.',
      landlordName: 'Mrs. Dela Cruz',
      landlordPhone: '+63 917 123 4567',
    ),
  ];

  static List<Room> get availableRooms =>
      mockRooms.where((r) => r.availability == 'available').toList();

  static List<Room> getRoomsForLandlord(String landlordId) =>
      mockRooms.where((r) => r.landlordId == landlordId).toList();

  static Room? getRoomById(String id) {
    for (final room in mockRooms) {
      if (room.id == id) return room;
    }
    return null;
  }

  static Student? getStudentById(String id) {
    for (final student in mockStudents) {
      if (student.id == id) return student;
    }
    return null;
  }

  static User? getUserById(String id) {
    final student = getStudentById(id);
    if (student != null) {
      return User(
        id: student.id,
        name: student.name,
        username: student.name,
        email: '',
        role: UserRole.student,
      );
    }

    for (var room in mockRooms) {
      if (room.landlordId == id) {
        return User(
          id: room.landlordId,
          name: room.landlordName,
          email: '',
          role: UserRole.landlord,
        );
      }
    }
    return null;
  }

  static List<Student> getRoommateMatches(Student currentStudent) {
    final matches = mockStudents
        .where((s) => s.id != currentStudent.id)
        .map((s) => MapEntry(s, calculateCompatibility(currentStudent, s)))
        .toList();
    matches.sort((a, b) => b.value.compareTo(a.value));
    return matches.map((e) => e.key).toList();
  }

  static int calculateCompatibility(Student student1, Student student2) {
    int score = 0;
    int maxScore = 0;

    maxScore += 25;
    if (student1.sleepSchedule == student2.sleepSchedule) score += 25;

    maxScore += 20;
    if (student1.studyHabit == student2.studyHabit) score += 20;

    maxScore += 20;
    if (student1.smoker == student2.smoker) score += 20;

    maxScore += 20;
    if (student1.cleanliness == student2.cleanliness) {
      score += 20;
    } else if ((student1.cleanliness == 'clean' &&
            student2.cleanliness == 'moderate') ||
        (student1.cleanliness == 'moderate' &&
            student2.cleanliness == 'clean')) {
      score += 10;
    }

    maxScore += 15;
    final shared = student1.personality
        .where((p) => student2.personality.contains(p))
        .length;
    final total = {...student1.personality, ...student2.personality}.length;
    if (total > 0) score += (shared / total * 15).round();

    return (score / maxScore * 100).round();
  }

  static Future<List<Room>> fetchAvailableRooms() async {
    try {
      return await SupabaseService.instance.fetchAvailableRooms();
    } catch (_) {
      return availableRooms;
    }
  }

  static Future<List<Room>> fetchRoomsForLandlord(String landlordId) async {
    try {
      return await SupabaseService.instance.fetchRoomsForLandlord(landlordId);
    } catch (_) {
      return getRoomsForLandlord(landlordId);
    }
  }

  static Future<Room?> fetchRoomByIdAsync(String id) async {
    try {
      return await SupabaseService.instance.fetchRoomById(id);
    } catch (_) {
      return getRoomById(id);
    }
  }

  static Future<List<Student>> fetchStudents() async {
    try {
      final students = await SupabaseService.instance.fetchStudents();
      return students.isNotEmpty ? students : mockStudents;
    } catch (_) {
      return mockStudents;
    }
  }

  static Future<User?> fetchUserByIdAsync(String id) async {
    try {
      return await SupabaseService.instance.fetchUserById(id);
    } catch (_) {
      return getUserById(id);
    }
  }
}
