import 'package:boardmate/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'services/supabase_service.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student_home_screen.dart';
import 'screens/browse_rooms_screen.dart';
import 'screens/room_details_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/student_profile_screen.dart';
import 'screens/landlord_profile_screen.dart';
import 'screens/landlord_dashboard_screen.dart';
import 'screens/post_room_screen.dart';
import 'screens/my_listings_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const BoardMateApp(),
    ),
  );
}

class BoardMateApp extends StatelessWidget {
  const BoardMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoardMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Blue-500
          primary: const Color(0xFF3B82F6),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF3B82F6),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF3B82F6),
            side: const BorderSide(color: Color(0xFF3B82F6)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');
        final path = uri.path;

        // Room details route
        if (path.startsWith('/room/')) {
          final roomId = path.split('/').last;
          return MaterialPageRoute(
            builder: (_) => RoomDetailsScreen(roomId: roomId),
          );
        }

        switch (path) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/student':
            return MaterialPageRoute(builder: (_) => const StudentHomeScreen());
          case '/browse':
            return MaterialPageRoute(builder: (_) => const BrowseRoomsScreen());
          case '/matches':
            return MaterialPageRoute(builder: (_) => const MatchesScreen());
          case '/profile':
            return MaterialPageRoute(
              builder: (context) {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                if (auth.user?.role == UserRole.landlord) {
                  return const LandlordProfileScreen();
                }
                return const StudentProfileScreen();
              },
            );
          case '/landlord-profile':
            return MaterialPageRoute(
              builder: (_) => const LandlordProfileScreen(),
            );
          case '/landlord':
            return MaterialPageRoute(
              builder: (_) => const LandlordDashboardScreen(),
            );
          case '/post-room':
            return MaterialPageRoute(builder: (_) => const PostRoomScreen());
          case '/my-listings':
            return MaterialPageRoute(builder: (_) => const MyListingsScreen());
          case '/chats':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const ChatListScreen(),
            );
          case '/chat_detail':
            if (settings.arguments is User) {
              final user = settings.arguments as User;
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ChatDetailScreen(otherUser: user),
              );
            }
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          default:
            // If route is unknown, go to AuthWrapper to check state instead of forcing Login
            return MaterialPageRoute(builder: (_) => const AuthWrapper());
        }
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const LoginScreen();
    }

    if (user.role == UserRole.student) {
      return const StudentHomeScreen();
    } else {
      return const LandlordDashboardScreen();
    }
  }
}
