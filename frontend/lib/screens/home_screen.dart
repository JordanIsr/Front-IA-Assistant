// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:frontend/screens/widgets/menu_drawer.dart';
import 'package:frontend/screens/voice_assistant/voice_wakeup_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedTitle;
  late AnimationController _animationController;

  // 🚀 NUEVO: Necesitamos un FocusNode para manejar el enfoque del scroll en Desktop/Web.
  final FocusNode _scrollFocusNode = FocusNode();
  final KeywordSpeechService _leslieVoice = KeywordSpeechService(); // ⬅️ AGREGA ESTO

  // Datos con recomendaciones (Los mismos 8 elementos)
  final List<Map<String, dynamic>> _supportMenus = const [
    {
      'title': 'Pérdida de un ser querido',
      'icon': Icons.healing,
      'color': Color(0xFF5D6D7E),
      'shortDescription': 'Navega por el duelo.',
      'recommendations': [
        'Permítete sentir el dolor sin juzgarte.',
        'Busca un grupo de apoyo o terapia psicológica.',
        'Mantén una rutina diaria, aunque sea simple.',
        'Recuerda y honra a tu ser querido a tu manera.',
      ],
    },
    {
      'title': 'Ruptura amorosa',
      'icon': Icons.heart_broken,
      'color': Color(0xFFEC7063),
      'shortDescription': 'Supera una separación.',
      'recommendations': [
        'Establece contacto cero para sanar.',
        'Redefine tu identidad fuera de la relación.',
        'Dedica tiempo a hobbies que habías abandonado.',
        'Habla con amigos y familiares sobre tus sentimientos.',
      ],
    },
    {
      'title': 'Estrés laboral',
      'icon': Icons.work,
      'color': Color(0xFFF4D03F),
      'shortDescription': 'Maneja el agotamiento.',
      'recommendations': [
        'Establece límites claros entre trabajo y vida personal.',
        'Practica la regla 20-20-20 (descansa la vista cada 20 minutos).',
        'Asegúrate de dormir al menos 7-8 horas.',
        'Usa técnicas de respiración profunda al sentir tensión.',
      ],
    },
    {
      'title': 'Ansiedad y preocupación',
      'icon': Icons.cloud_queue,
      'color': Color(0xFF58D683),
      'shortDescription': 'Calma tu mente.',
      'recommendations': [
        'Prueba la técnica de los 5 sentidos (mindfulness).',
        'Reduce el consumo de cafeína y azúcar.',
        'Realiza actividad física diaria (caminar es suficiente).',
        'Escribe tus preocupaciones para sacarlas de tu mente.',
      ],
    },
    {
      'title': 'Metas y motivación',
      'icon': Icons.rocket_launch,
      'color': Colors.deepPurple,
      'shortDescription': 'Alcanza tus sueños.',
      'recommendations': [
        'Divide tus grandes metas en pequeños pasos alcanzables.',
        'Crea un tablero de visión (vision board) de tus objetivos.',
        'Celebra los pequeños logros para mantener el impulso.',
        'Encuentra un "accountability partner" que te motive.',
      ],
    },
    {
      'title': 'Dificultad para dormir',
      'icon': Icons.nightlight_round,
      'color': Color(0xFF3498DB),
      'shortDescription': 'Mejora tu descanso.',
      'recommendations': [
        'Establece un horario de sueño regular.',
        'Evita pantallas una hora antes de acostarte.',
        'Crea un ambiente oscuro y fresco.',
        'Practica meditación suave antes de dormir.',
      ],
    },
    {
      'title': 'Manejo de la ira',
      'icon': Icons.flash_on,
      'color': Color(0xFFCD6155),
      'shortDescription': 'Controla tus impulsos.',
      'recommendations': [
        'Cuenta hasta diez antes de reaccionar.',
        'Identifica los disparadores de tu ira.',
        'Practica ejercicios de relajación profunda.',
        'Escribe en un diario para liberar tensiones.',
      ],
    },
    {
      'title': 'Soledad',
      'icon': Icons.people_outline,
      'color': Color(0xFF9B59B6),
      'shortDescription': 'Conéctate con otros.',
      'recommendations': [
        'Únete a un club o actividad grupal.',
        'Contacta a un amigo que no has visto.',
        'Sé voluntario en tu comunidad.',
        'Acepta invitaciones sociales, aunque te cueste.',
      ],
    },
  ];

  @override
void initState() {
  super.initState();

  _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  // ✅ INICIALIZAR LA ESCUCHA DE "LESLIE"
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

  _leslieVoice.init(); // 🚀 ahora sí empieza a escuchar
}


  @override
  void dispose() {
    _animationController.dispose();
    // 🚀 IMPORTANTE: Desechar el FocusNode al final
    _scrollFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lógica para el popup de recomendaciones
    final selectedMenu = _supportMenus.firstWhere(
      (menu) => menu['title'] == _selectedTitle,
      orElse: () => {},
    );
    final bool showRecommendations =
        _selectedTitle != null && selectedMenu.isNotEmpty;

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
            // 🚀 CAMBIO CLAVE: Usamos un widget Focus para dar enfoque al scroll
            Focus(
              autofocus: true, // Pide el foco automáticamente al cargar
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
                      itemCount: _supportMenus.length,
                      itemBuilder: (context, index) {
                        return _buildSupportGridItem(_supportMenus[index]);
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // POPUP DE RECOMENDACIONES
            if (showRecommendations)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: _buildRecommendationsPopup(selectedMenu),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      // Botón Flotante Animado para el Chat (Posición fija)
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

      // BottomAppBar para crear el espacio para el botón
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
    final bool isSelected = _selectedTitle == title;

    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side:
            isSelected
                ? BorderSide(color: color.withOpacity(0.5), width: 2)
                : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTitle = isSelected ? null : title;
          });
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTitle = isSelected ? null : title;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? color.withOpacity(0.1) : color,
                        foregroundColor: isSelected ? color : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        elevation: 0,
                      ),
                      child: Text(
                        isSelected ? 'Ocultar' : 'Ver todo',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

  Widget _buildRecommendationsPopup(Map<String, dynamic> menu) {
    final title = menu['title'] as String;
    final color = menu['color'] as Color;
    final recommendations = menu['recommendations'] as List<String>;

    // (Código del popup)
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  color: Colors.grey.shade600,
                  onPressed: () {
                    setState(() {
                      _selectedTitle = null;
                    });
                  },
                ),
              ],
            ),
            const Divider(height: 25),
            const Text(
              'Pasos a seguir:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...recommendations
                .map(
                  (recommendation) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: color,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: const TextStyle(fontSize: 15, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),

            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                icon: const Icon(Icons.psychology_alt, color: Colors.white),
                label: const Text(
                  'Hablar con la IA',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
