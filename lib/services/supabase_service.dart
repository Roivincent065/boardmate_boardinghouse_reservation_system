import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/message.dart';
import '../models/room.dart';
import '../models/student.dart';
import '../models/user.dart' as app_models;

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  SupabaseClient get client => Supabase.instance.client;

  Future<app_models.User?> currentUser() async {
    final sessionUser = client.auth.currentUser;
    if (sessionUser == null) return null;

    final profileResponse = await client
        .from('profiles')
        .select()
        .eq('id', sessionUser.id)
        .maybeSingle();

    final profileData = _extractResponseData(profileResponse);
    if (profileResponse == null ||
        _responseHasError(profileResponse) ||
        profileData == null) {
      return _userFromRow({
        'id': sessionUser.id,
        'name': sessionUser.userMetadata?['name'] as String? ?? '',
        'username': sessionUser.userMetadata?['username'] as String? ?? '',
        'email': sessionUser.email ?? '',
        'role': 'student',
      });
    }

    return _userFromRow(profileData as Map<String, dynamic>);
  }

  Future<app_models.User?> login(
    String email,
    String password,
    app_models.UserRole role,
  ) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response == null || response.user == null) {
      throw Exception('Login failed');
    }

    final userId = response.user!.id;
    final profileResponse = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    final profileData = _extractResponseData(profileResponse);
    if (profileResponse == null ||
        _responseHasError(profileResponse) ||
        profileData == null) {
      final fallbackProfile = {
        'id': userId,
        'name': response.user!.userMetadata?['name'] as String? ?? '',
        'username': response.user!.userMetadata?['username'] as String? ?? '',
        'email': response.user!.email ?? '',
        'role': role.name,
      };

      final insertResponse = await client
          .from('profiles')
          .insert(fallbackProfile)
          .select()
          .maybeSingle();

      final insertData = _extractResponseData(insertResponse);
      if (insertResponse != null &&
          !_responseHasError(insertResponse) &&
          insertData != null) {
        return _userFromRow(insertData as Map<String, dynamic>);
      }

      return _userFromRow(fallbackProfile);
    }

    final user = _userFromRow(profileData as Map<String, dynamic>);
    if (user.role != role) {
      throw Exception(
        'User role mismatch. Please login with the correct role.',
      );
    }

    return user;
  }

  Future<app_models.User?> register(
    String name,
    String email,
    String password,
    String username,
    app_models.UserRole role,
  ) async {
    final response = await client.auth.signUp(email: email, password: password);

    if (response == null || response.user == null) {
      throw Exception('Registration failed');
    }

    final userId = response.user!.id;
    final profileRow = {
      'id': userId,
      'name': name,
      'username': username,
      'email': email,
      'role': role.name,
      'school': null,
      'budget_min': null,
      'budget_max': null,
      'preferred_location': null,
      'move_in_date': null,
      'study_habit': null,
      'personality': jsonEncode(<String>[]),
      'smoker': false,
      'sleep_schedule': null,
      'cleanliness': null,
    };
    // Try to create a profile row. On some auth flows (email confirmation required)
    // the client may not have a session yet, causing a 403. In that case, return
    // a fallback user built from the auth response and let the client create the
    // full profile after the user completes sign-in/confirmation.
    final insertResponse = await client
        .from('profiles')
        .insert(profileRow)
        .select()
        .maybeSingle();

    final insertData = _extractResponseData(insertResponse);
    if (insertResponse == null ||
        _responseHasError(insertResponse) ||
        insertData == null) {
      // If creation failed due to permission/session, return a minimal user
      // constructed from the auth user so the app can proceed.
      return _userFromRow({
        'id': userId,
        'name': name,
        'username': username,
        'email': email,
        'role': role.name,
      });
    }

    return _userFromRow(insertData as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  Future<List<Room>> fetchAvailableRooms() async {
    final response = await client
        .from('rooms')
        .select()
        .eq('availability', 'available');

    if (response == null || _responseHasError(response)) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to fetch rooms',
      );
    }

    return _roomListFromData(_extractResponseData(response));
  }

  Future<List<Room>> fetchRoomsForLandlord(String landlordId) async {
    final response = await client
        .from('rooms')
        .select()
        .eq('landlord_id', landlordId);

    if (response == null || _responseHasError(response)) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to fetch landlord rooms',
      );
    }

    return _roomListFromData(_extractResponseData(response));
  }

  Future<Room?> fetchRoomById(String roomId) async {
    final response = await client
        .from('rooms')
        .select()
        .eq('id', roomId)
        .maybeSingle();

    if (response == null || _responseHasError(response)) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to fetch room details',
      );
    }

    final roomData = _extractResponseData(response);
    if (roomData == null) return null;
    return _roomFromRow(roomData as Map<String, dynamic>);
  }

  Future<List<Student>> fetchStudents() async {
    final response = await client
        .from('profiles')
        .select()
        .eq('role', 'student');

    if (response == null || _responseHasError(response)) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to fetch students',
      );
    }

    final data = _extractResponseData(response) as List<dynamic>?;
    if (data == null) return [];

    return data
        .cast<Map<String, dynamic>>()
        .map((row) => _studentFromRow(row))
        .toList();
  }

  Future<app_models.User?> fetchUserById(String id) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null || _responseHasError(response)) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to fetch user',
      );
    }

    final userData = _extractResponseData(response);
    if (userData == null) return null;
    return _userFromRow(userData as Map<String, dynamic>);
  }

  Future<List<Message>> fetchConversation(
    String currentUserId,
    String otherUserId,
  ) async {
    final response = await client
        .from('messages')
        .select()
        .or(
          'and(sender_id.eq.$currentUserId,receiver_id.eq.$otherUserId),'
          'and(sender_id.eq.$otherUserId,receiver_id.eq.$currentUserId)',
        )
        .order('timestamp', ascending: true);

    if (response == null || _responseHasError(response)) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to fetch conversation',
      );
    }

    final data = _extractResponseData(response) as List<dynamic>?;
    if (data == null) return [];

    return data
        .cast<Map<String, dynamic>>()
        .map((row) => _messageFromRow(row))
        .toList();
  }

  Future<Message> sendMessage(
    String senderId,
    String receiverId,
    String text,
  ) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final payload = {
      'id': messageId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    final response = await client
        .from('messages')
        .insert(payload)
        .select()
        .maybeSingle();
    final responseData = _extractResponseData(response);
    if (response == null ||
        _responseHasError(response) ||
        responseData == null) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to send message',
      );
    }

    return _messageFromRow(responseData as Map<String, dynamic>);
  }

  Future<String> uploadRoomPhoto(String imagePath, String roomId) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('File not found: $imagePath');
      }

      // Create a unique filename using timestamp
      final fileName =
          '$roomId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final bucketName = 'room-photos';

      // Upload to Supabase Storage
      final response = await client.storage.from(bucketName).upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final publicUrl =
          client.storage.from(bucketName).getPublicUrl(response);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: ${e.toString()}');
    }
  }

  Future<Room?> createRoom({
    required String landlordId,
    required String title,
    required int price,
    required int deposit,
    required String address,
    required String location,
    required int capacity,
    required List<String> amenities,
    required List<String> photos,
    required String description,
    required String landlordName,
    required String landlordPhone,
  }) async {
    final roomId = DateTime.now().millisecondsSinceEpoch.toString();
    final payload = {
      'id': roomId,
      'landlord_id': landlordId,
      'title': title,
      'price': price,
      'deposit': deposit,
      'address': address,
      'location': location,
      'capacity': capacity,
      'current_occupants': 0,
      'amenities': jsonEncode(amenities),
      'photos': jsonEncode(photos),
      'availability': 'available',
      'description': description,
      'landlord_name': landlordName,
      'landlord_phone': landlordPhone,
    };

    final response = await client
        .from('rooms')
        .insert(payload)
        .select()
        .maybeSingle();

    final responseData = _extractResponseData(response);
    if (response == null ||
        _responseHasError(response) ||
        responseData == null) {
      throw Exception(
        _responseErrorMessage(response) ?? 'Failed to create room',
      );
    }

    return _roomFromRow(responseData as Map<String, dynamic>);
  }
    final roleString = row['role']?.toString() ?? 'student';
    final role = app_models.UserRole.values.firstWhere(
      (value) => value.name == roleString,
      orElse: () => app_models.UserRole.student,
    );
    return app_models.User(
      id: row['id'] as String,
      name: row['name'] as String? ?? '',
      username: row['username'] as String? ?? '',
      email: row['email'] as String? ?? '',
      role: role,
    );
  }

  Room _roomFromRow(Map<String, dynamic> row) {
    return Room(
      id: row['id'] as String,
      landlordId: row['landlord_id'] as String? ?? '',
      title: row['title'] as String? ?? '',
      price: _intFromValue(row['price']),
      deposit: _intFromValue(row['deposit']),
      address: row['address'] as String? ?? '',
      location: row['location'] as String? ?? '',
      capacity: _intFromValue(row['capacity']),
      currentOccupants: _intFromValue(row['current_occupants']),
      amenities: _listFromValue(row['amenities']),
      photos: _listFromValue(row['photos']),
      availability: row['availability'] as String? ?? 'available',
      description: row['description'] as String? ?? '',
      landlordName: row['landlord_name'] as String? ?? '',
      landlordPhone: row['landlord_phone'] as String? ?? '',
    );
  }

  List<Room> _roomListFromData(dynamic data) {
    if (data is! List) return [];
    return data.cast<Map<String, dynamic>>().map(_roomFromRow).toList();
  }

  Student _studentFromRow(Map<String, dynamic> row) {
    return Student(
      id: row['id'] as String,
      name: row['name'] as String? ?? '',
      avatar: row['avatar'] as String? ?? '',
      school: row['school'] as String? ?? '',
      budgetMin: _intFromValue(row['budget_min']),
      budgetMax: _intFromValue(row['budget_max']),
      preferredLocation: row['preferred_location'] as String? ?? '',
      moveInDate: row['move_in_date'] as String? ?? '',
      studyHabit: row['study_habit'] as String? ?? '',
      personality: _listFromValue(row['personality']),
      smoker: row['smoker'] == true,
      sleepSchedule: row['sleep_schedule'] as String? ?? '',
      cleanliness: row['cleanliness'] as String? ?? '',
    );
  }

  Message _messageFromRow(Map<String, dynamic> row) {
    final timestamp = _dateTimeFromValue(row['timestamp']);
    return Message(
      id: row['id'] as String,
      senderId: row['sender_id'] as String? ?? '',
      receiverId: row['receiver_id'] as String? ?? '',
      text: row['text'] as String? ?? '',
      timestamp: timestamp,
    );
  }

  int _intFromValue(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  List<String> _listFromValue(Object? value) {
    if (value == null) return [];
    if (value is List) return value.cast<String>();
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.cast<String>();
        }
      } catch (_) {
        return [value];
      }
    }
    return [];
  }

  DateTime _dateTimeFromValue(Object? value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now().toUtc();
    }
    return DateTime.now().toUtc();
  }

  dynamic _extractResponseData(dynamic response) {
    if (response is Map<String, dynamic> || response is List) return response;
    try {
      return response.data;
    } catch (_) {
      return null;
    }
  }

  bool _responseHasError(dynamic response) {
    if (response is Map<String, dynamic> || response is List) return false;
    try {
      return response.error != null;
    } catch (_) {
      return false;
    }
  }

  String? _responseErrorMessage(dynamic response) {
    if (response is Map<String, dynamic> || response is List) return null;
    try {
      return response.error?.message;
    } catch (_) {
      return null;
    }
  }
}
