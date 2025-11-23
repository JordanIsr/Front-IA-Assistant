// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/api_service.dart';

// 🎤 Servicios nuevos
import 'package:frontend/screens/services/speech_service.dart';
import 'package:frontend/screens/services/text_to_speech_service.dart';

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
  late bool _isNewConversation;

  bool _isSending = false;

  // 🎤 Instancias de servicios de voz
  final SpeechService _speechService = SpeechService();
  final TextToSpeechService _tts = TextToSpeechService();

  @override
  void initState() {
    super.initState();

    if (widget.conversationId == null) {
      _conversationId = DateTime.now().millisecondsSinceEpoch.toString();
      _isNewConversation = true;
    } else {
      _conversationId = widget.conversationId!;
      _isNewConversation = false;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // 🎤 Función para procesar voz → texto
  Future<void> _handleVoiceInput() async {
    final text = await _speechService.startListening();
    if (text == null || text.isEmpty) return;

    setState(() {
      _messageController.text = text;
    });

    await _sendMessage();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentUser == null || _isSending) return;

    setState(() => _isSending = true);
    _messageController.clear();
    FocusScope.of(context).unfocus();

    try {
      if (_isNewConversation) {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(_currentUser.uid)
            .collection('conversations')
            .doc(_conversationId)
            .set({
              'createdAt': FieldValue.serverTimestamp(),
              'title': 'Nueva conversación',
            });

        _isNewConversation = false;
      }

      // guardar mensaje de usuario
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

      // llamar API
      final aiResponse = await ApiService.sendMessage(text);

      // guardar respuesta IA
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

      // 🔊 IA habla su respuesta
      await _tts.speak(aiResponse);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar: $e')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  Widget _buildMessagesList() {
    if (_currentUser == null) {
      return const Center(child: Text("No hay usuario logueado."));
    }

    if (_isNewConversation) {
      return const Center(
        child: Text(
          "Aún no hay mensajes.\n¡Dile hola a tu asistente!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
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
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "Aún no hay mensajes.\n¡Dile hola a tu asistente!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final messages = snap.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, i) {
            final msg = messages[i].data() as Map<String, dynamic>;
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  msg['text'],
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
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🎤 BOTÓN DE MICRO
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: _handleVoiceInput,
            ),
          ),

          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Escribe tu mensaje...",
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
            accountName: Text(_currentUser?.email?.split("@")[0] ?? "Usuario"),
            accountEmail: Text(_currentUser?.email ?? "Sin correo"),
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
            title: const Text("Nuevo Chat"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.blueAccent),
            title: const Text("Historial del Chat"),
            onTap: () => Navigator.pushNamed(context, '/historial'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blueAccent),
            title: const Text("Inicio"),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.purple),
            title: const Text("Librería"),
            onTap: () => Navigator.pushNamed(context, '/library'),
          ),
          ListTile(
            leading: const Icon(Icons.toys_outlined, color: Colors.orange),
            title: const Text("Zona Anti-Estrés"),
            onTap: () => Navigator.pushNamed(context, '/distraction-zone'),
          ),
          ListTile(
            leading: const Icon(
              Icons.medical_services,
              color: Colors.redAccent,
            ),
            title: const Text("Recursos y Especialistas"),
            onTap: () => Navigator.pushNamed(context, '/professional-help'),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text("Configuración"),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Cerrar Sesión"),
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
          "Asistente IA",
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
