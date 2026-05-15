import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/user.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _loadCurrentUser();
    _listenToAuthChanges();
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isStudent => _user?.role == UserRole.student;
  bool get isLandlord => _user?.role == UserRole.landlord;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadCurrentUser({User? fallback}) async {
    _setLoading(true);
    try {
      final fetchedUser = await SupabaseService.instance.currentUser();
      if (fetchedUser != null) {
        _user = fetchedUser;
      } else if (fallback != null) {
        _user = fallback;
      }
    } catch (_) {
      if (fallback != null) {
        _user = fallback;
      }
    } finally {
      _setLoading(false);
    }
  }

  void _listenToAuthChanges() {
    supabase.Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.session != null) {
        final sessionUser = event.session!.user;
        if (sessionUser != null) {
          final fallback = _fallbackUserFromSession(sessionUser);
          _user = fallback;
          notifyListeners();
          _loadCurrentUser(fallback: fallback);
        }
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  User _fallbackUserFromSession(supabase.User sessionUser) {
    final email = sessionUser.email ?? '';
    final name = sessionUser.userMetadata?['name'] as String? ?? '';
    final username = sessionUser.userMetadata?['username'] as String? ?? '';
    return User(
      id: sessionUser.id,
      name: name,
      username: username,
      email: email,
      role: UserRole.student,
    );
  }

  Future<void> login(String email, String password, UserRole role) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await SupabaseService.instance.login(email, password, role);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String username,
    UserRole role,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await SupabaseService.instance.register(
        name,
        email,
        password,
        username,
        role,
      );
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await SupabaseService.instance.logout();
      _user = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
