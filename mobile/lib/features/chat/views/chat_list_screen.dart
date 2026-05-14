import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(chatParticipantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: participantsAsync.when(
        data: (participants) {
          if (participants.isEmpty) {
            return const Center(child: Text('No staff or users found in your company'));
          }
          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final user = participants[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getRoleColor(user.role),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(user.phone),
                subtitle: Text(user.role.toUpperCase()),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () {
                  Get.to(() => ChatScreen(
                    otherUserId: user.id,
                    otherUserName: '${user.phone} (${user.role})',
                  ));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'staff':
        return Colors.green;
      case 'user':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
