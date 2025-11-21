import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario logueado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial del Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3f2fd), Color(0xffbbdefb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(currentUser.uid)
                  .collection('conversations')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No hay conversaciones guardadas.'),
              );
            }

            final chats = snapshot.data!.docs;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final title = chat['title'] ?? 'Conversación sin título';
                final timestamp = chat['createdAt'] as Timestamp?;
                final fecha = timestamp?.toDate();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.chat_bubble,
                      color: Colors.blueAccent,
                    ),
                    title: Text(title),
                    subtitle:
                        fecha != null
                            ? Text('${fecha.day}/${fecha.month}/${fecha.year}')
                            : const Text('Sin fecha'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(conversationId: chat.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
