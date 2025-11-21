import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/api_service.dart'; // ✅ Ahora sí se usa

class ChatScreen extends StatefulWidget {
  final String? conversationId;
  const ChatScreen({super.key, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  late String _conversationId;
  bool _isSending = false; // Para evitar doble envío

  @override
  void initState() {
    super.initState();

    // Si no se pasa ID, crear uno nuevo
    _conversationId =
        widget.conversationId ??
        DateTime.now().millisecondsSinceEpoch.toString();

    // Si es nuevo, registrar la conversación
    if (widget.conversationId == null && _currentUser != null) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(_currentUser.uid)
          .collection('conversations')
          .doc(_conversationId)
          .set({
            'createdAt': FieldValue.serverTimestamp(),
            'title': 'Nueva conversación',
          });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentUser == null || _isSending) return;

    setState(() => _isSending = true);
    _messageController.clear();
    FocusScope.of(context).unfocus();

    try {
      // Guardar mensaje del usuario en Firestore
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_currentUser.uid)
          .collection('conversations')
          .doc(_conversationId)
          .collection('messages')
          .add({
            'text': text,
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'user',
          });

      // ✅ Llamar a la API de tu backend (api_service.dart)
      final aiResponse = await ApiService.sendMessage(text);

      // Guardar respuesta de la IA
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_currentUser.uid)
          .collection('conversations')
          .doc(_conversationId)
          .collection('messages')
          .add({
            'text': aiResponse,
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'assistant',
          });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar mensaje: $e')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  Widget _buildMessagesList() {
    if (_currentUser == null) {
      return const Center(child: Text('No hay usuario logueado.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .doc(_currentUser.uid)
              .collection('conversations')
              .doc(_conversationId)
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Aún no hay mensajes.\n¡Dile hola a tu asistente!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final messages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index].data() as Map<String, dynamic>;
            final isUser = msg['role'] == 'user';

            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blueAccent : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft:
                        isUser ? const Radius.circular(16) : Radius.zero,
                    bottomRight:
                        isUser ? Radius.zero : const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  msg['text'] ?? '',
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_currentUser?.email?.split('@')[0] ?? 'Usuario'),
            accountEmail: Text(_currentUser?.email ?? 'Sin correo'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff42a5f5), Color(0xff1e88e5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_comment, color: Colors.green),
            title: const Text('Nuevo Chat'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.blueAccent),
            title: const Text('Historial del Chat'),
            onTap: () => Navigator.pushNamed(context, '/historial'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text(
          'Asistente IA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3f2fd), Color(0xffbbdefb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildMessagesList()),
              _buildMessageInputBar(),
            ],
          ),
        ),
      ),
    );
  }
}
