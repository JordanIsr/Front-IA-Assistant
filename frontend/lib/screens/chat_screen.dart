// ARCHIVO: frontend/lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Necesario para el retraso del bot

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isBotTyping = false; // Para mostrar "Bot está escribiendo..."

  // --- LÓGICA DE LA APP ---

  void _handleSendPressed() {
    final text = _textController.text;
    if (text.isEmpty || _isBotTyping) return;

    _textController.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isBotTyping = true; // El bot empieza a "pensar"
    });
    _scrollToBottom();

    // Llamamos a la lógica del bot simulado
    _callSmartBot(text);
  }

  // --- LÓGICA DE BOT INTELIGENTE (SIN INTERNET) ---

  // Esta función decide qué responder
  String _getBotResponse(String userMessage) {
    String message = userMessage.toLowerCase();

    // Respuestas pre-programadas
    final Map<String, String> responses = {
      'hola': '¡Hola! ¿Cómo te sientes hoy?',
      'bien': '¡Me alegra escuchar eso! ¿En qué puedo ayudarte?',
      'mal': 'Lamento escuchar eso. ¿Quieres hablar sobre lo que te sucede?',
      'triste':
          'Está bien sentirse triste a veces. Hablar de ello puede ayudar. ¿Qué te pasa?',
      'depresion':
          'La depresión es un tema serio. Recuerda que no estás solo y hablar con un profesional puede ser de gran ayuda.',
      'ansiedad':
          'La ansiedad es una reacción común. Intenta respirar profundo. ¿Qué está causando tu ansiedad ahora mismo?',
      'ayuda':
          'Estoy aquí para escucharte. También puedes contactar a líneas de apoyo profesional si lo necesitas.',
      'adios':
          'Que tengas un buen día. Recuerda que estoy aquí si necesitas hablar.',
    };

    // Buscamos una palabra clave
    for (String keyword in responses.keys) {
      if (message.contains(keyword)) {
        return responses[keyword]!; // Devuelve la respuesta asociada
      }
    }

    // Respuesta genérica
    return 'Entendido. Es un tema interesante. ¿Puedes contarme más al respecto?';
  }

  // Esta función "simula" el pensamiento del bot
  void _callSmartBot(String userMessage) {
    // Simular un retraso de 1 segundo
    Timer(const Duration(seconds: 1), () {
      String botReply = _getBotResponse(userMessage);

      setState(() {
        _isBotTyping = false; // El bot deja de "pensar"
        _messages.add({'sender': 'bot', 'text': botReply});
      });
      _scrollToBottom();
    });
  }

  // --- FIN DE LA LÓGICA DEL BOT ---

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Personal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      // --- MENÚ LATERAL (DRAWER) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Historial de Chats',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Opciones simuladas
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Clonar Repositorio Git'), //
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Anime Mitológico'), //
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Nueva Conversación'), //
              onTap: () {
                // Reinicia el chat
                Navigator.pop(context); // Cierra el drawer
                setState(() {
                  _messages.clear(); // Borra los mensajes
                });
              },
            ),
          ],
        ),
      ),

      // --- FIN DEL MENÚ LATERAL ---
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // Muestra el indicador de "escribiendo..."
                if (index == _messages.length && _isBotTyping) {
                  return const _TypingIndicator();
                }

                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';

                return _ChatMessageBubble(
                  text: message['text']!,
                  isUserMessage: isUserMessage,
                );
              },
            ),
          ),
          _buildChatInputBar(),
        ],
      ),
    );
  }

  // Barra de entrada de texto
  Widget _buildChatInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (_) => _handleSendPressed(),
            ),
          ),
          // Botón de enviar (se deshabilita si el bot está escribiendo)
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isBotTyping ? null : _handleSendPressed,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PARA LA BURBUJA DE CHAT ---
class _ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const _ChatMessageBubble({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    final alignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isUserMessage ? Colors.blue[100] : Colors.grey[200];
    final textColor = isUserMessage ? Colors.black87 : Colors.black;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
        ),
      ],
    );
  }
}

// --- WIDGET PARA EL INDICADOR DE "ESCRIBIENDO..." ---
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          // Usamos 3 puntos como en apps de mensajería
          child: const Text(
            "...",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
