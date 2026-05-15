import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/bottom_nav.dart';
import '../providers/data_provider.dart';
import '../models/user.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chatProvider = context.watch<ChatProvider>();

    if (auth.user == null)
      return const Scaffold(body: Center(child: Text('Please login')));

    // Logic to find unique chat partners
    final currentUserId = auth.user!.id;
    final uniquePartnerIds = <String>{};
    for (var m in chatProvider.messages) {
      if (m.senderId == currentUserId) uniquePartnerIds.add(m.receiverId);
      if (m.receiverId == currentUserId) uniquePartnerIds.add(m.senderId);
    }

    final partners = uniquePartnerIds.toList();

    // Helper to get last message for a partner
    String getLastMessage(String partnerId) {
      final conversation = chatProvider.getConversation(
        currentUserId,
        partnerId,
      );
      return conversation.isNotEmpty ? conversation.last.text : '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: partners.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: partners.length,
              itemBuilder: (context, index) {
                final partnerId = partners[index];
                final partnerUser = DataProvider.getUserById(partnerId);

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(partnerUser?.displayName ?? 'User $partnerId'),
                  subtitle: Text(
                    getLastMessage(partnerId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    if (partnerUser != null) {
                      Navigator.pushNamed(
                        context,
                        '/chat_detail',
                        arguments: partnerUser,
                      );
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to start a new chat with a landlord or student
        },
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 3,
        isLandlord: auth.isLandlord,
        onTap: (index) {
          if (auth.isLandlord) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/landlord');
                break;
              case 1:
                Navigator.pushNamed(context, '/post-room');
                break;
              case 2:
                Navigator.pushNamed(context, '/my-listings');
                break;
              case 3:
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          } else {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/student');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/browse');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/matches');
                break;
              case 3:
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          }
        },
      ),
    );
  }
}
