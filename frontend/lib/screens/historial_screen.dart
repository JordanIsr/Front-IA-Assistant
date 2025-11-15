import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart'; // Asegúrate de que este archivo exista

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  // -----------------------------------------------------------
  // FUNCIONES DE MANEJO DE DATOS (Firestore)
  // -----------------------------------------------------------

  /// Muestra un diálogo de confirmación para la eliminación.
  Future<bool?> _showDeleteConfirmDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: Text(
            "¿Estás seguro de que quieres eliminar la conversación: $title?",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancelar
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirmar
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  /// Elimina la conversación y todos sus mensajes asociados en Firestore.
  Future<void> _deleteConversation(String conversationId) async {
    if (currentUser == null) return;

    try {
      // 1. Eliminar todos los mensajes dentro de la subcolección 'messages'
      final conversationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(currentUser!.uid)
          .collection('conversations')
          .doc(conversationId);

      final messagesSnapshot =
          await conversationRef.collection('messages').get();

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // 2. Eliminar el documento de la conversación principal
      await conversationRef.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversación eliminada con éxito.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
      }
    }
  }

  /// Actualiza el título de la conversación en Firestore.
  Future<void> _renameConversation(
    String conversationId,
    String newTitle,
  ) async {
    final cleanTitle = newTitle.trim();
    if (currentUser == null || cleanTitle.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(currentUser!.uid)
          .collection('conversations')
          .doc(conversationId)
          .update({'title': cleanTitle});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Título actualizado con éxito.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al renombrar: $e')));
      }
    }
  }

  // -----------------------------------------------------------
  // FUNCIONES DE MANEJO DE UI (Diálogos)
  // -----------------------------------------------------------

  /// Muestra el diálogo para que el usuario ingrese un nuevo nombre.
  void _showRenameDialog(String conversationId, String currentTitle) {
    TextEditingController controller = TextEditingController(
      text: currentTitle,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renombrar Conversación'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nuevo título'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _renameConversation(conversationId, controller.text);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // -----------------------------------------------------------
  // WIDGET PRINCIPAL
  // -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
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
                  .doc(currentUser!.uid)
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
                final conversationId = chat.id;
                final title = chat['title'] ?? 'Conversación sin título';
                final timestamp = chat['createdAt'] as Timestamp?;
                final fecha = timestamp?.toDate();

                // Usamos Dismissible para la funcionalidad de "deslizar para eliminar"
                return Dismissible(
                  key: ValueKey(conversationId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Mostrar diálogo de confirmación antes de eliminar por deslizamiento
                    return await _showDeleteConfirmDialog(title);
                  },
                  onDismissed: (direction) {
                    // Eliminar si la confirmación fue exitosa
                    _deleteConversation(conversationId);
                  },
                  child: Card(
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
                              ? Text(
                                '${fecha.day}/${fecha.month}/${fecha.year}',
                              )
                              : const Text('Sin fecha'),

                      // --- MENÚ DE TRES PUNTOS (POPUP MENU) ---
                      trailing: PopupMenuButton<String>(
                        onSelected: (String result) async {
                          if (result == 'rename') {
                            _showRenameDialog(conversationId, title);
                          } else if (result == 'delete') {
                            // Mostrar diálogo de confirmación antes de eliminar por menú
                            final confirm = await _showDeleteConfirmDialog(
                              title,
                            );
                            if (confirm == true) {
                              _deleteConversation(conversationId);
                            }
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'rename',
                                child: Text('Renombrar'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Eliminar'),
                              ),
                            ],
                        icon: const Icon(Icons.more_vert), // Los tres puntos
                      ),

                      // --- FIN MENÚ POPUP ---
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    ChatScreen(conversationId: conversationId),
                          ),
                        );
                      },
                    ),
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
