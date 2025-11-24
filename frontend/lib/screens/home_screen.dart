// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:frontend/screens/widgets/menu_drawer.dart';
import 'package:frontend/screens/voice_assistant/voice_wakeup_service.dart';
// 1. IMPORTAMOS TUS DATOS NUEVOS
import 'package:frontend/data/support_data.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  
  // 🗑️ BORRADO: Ya no necesitamos _selectedTitle porque cambiamos de pantalla
  late AnimationController _animationController;

  final FocusNode _scrollFocusNode = FocusNode();
  final KeywordSpeechService _leslieVoice = KeywordSpeechService();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _leslieVoice.onMessageReady = (msg) {
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: {
          "fromVoice": true,
          "voiceText": msg,
        },
      );
    };

    _leslieVoice.init();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🗑️ BORRADO: Lógica del popup eliminada

    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text(
          'Mi Espacio de Apoyo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF8F9FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Focus(
              autofocus: true,
              focusNode: _scrollFocusNode,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildWelcomeCard(),

                    const SizedBox(height: 25),

                    const Text(
                      'Encuentra tu soporte emocional inmediato:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.1,
                      ),
                      // 2. USAMOS LA LISTA IMPORTADA DE 'support_data.dart'
                      itemCount: supportMenusData.length,
                      itemBuilder: (context, index) {
                        return _buildSupportGridItem(supportMenusData[index]);
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // 🗑️ BORRADO: El widget del Popup se eliminó de aquí
          ],
        ),
      ),

      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final colorTween = ColorTween(
            begin: Colors.teal.shade400,
            end: Colors.teal.shade700,
          );
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
            label: const Text(
              'Chatea con la IA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            icon: const Icon(Icons.psychology_alt),
            backgroundColor: colorTween.evaluate(_animationController),
            foregroundColor: Colors.white,
            elevation: 10,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        height: 50,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black12,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.spa_outlined, color: Colors.teal, size: 40),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Estamos aquí para ti. Explora los temas o inicia una conversación.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportGridItem(Map<String, dynamic> menu) {
    final title = menu['title'] as String;
    final color = menu['color'] as Color;
    final shortDescription = menu['shortDescription'] as String;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // 3. AQUÍ ESTÁ LA MAGIA: Navegamos a la nueva pantalla bonita
        onTap: () {
          Navigator.pushNamed(
            context,
            '/topic-detail',
            arguments: menu, // Le pasamos todos los datos (foto, texto, links)
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: color.withOpacity(0.1),
                child: Center(
                  child: Icon(menu['icon'] as IconData, color: color, size: 40),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    shortDescription,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Botón decorativo (ya que toda la tarjeta es clickeable)
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'Ver recursos',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}