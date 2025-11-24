import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedTopic = 'Todos';
  final List<Map<String, String>> _allBooks = [
    {
      'title': 'La Inteligencia Emocional',
      'author': 'Daniel Goleman',
      'topic': 'Autoestima y Resiliencia',
      'pdfPath': 'assets/pdfs/La-Inteligencia-Emocional-Daniel-Goleman-1.pdf',
    },
    {
      'title': 'El Miedo a la Libertad',
      'author': 'Erich Fromm',
      'topic': 'Ansiedad y Estrés',
      'pdfPath': 'assets/pdfs/04.-Erich-Fromm-El-miedo-a-la-libertad.pdf',
    },
    {
      'title': 'Tus Zonas Erróneas',
      'author': 'Wayne Dyer',
      'topic': 'Relaciones Personales',
      'pdfPath': 'assets/pdfs/Tus-zonas-erróneas.pdf',
    },
    {
      'title': 'Pensar Bien, Sentirse Bien',
      'author': 'Walter Riso',
      'topic': 'Mindfulness y Bienestar',
      'pdfPath': 'assets/pdfs/risowalterpensarbiensentirsebien.pdf',
    },
    // Estos son ejemplos adicionales que debes crear en tu carpeta si quieres usarlos:
    {
      'title': 'Gestionando la Ansiedad',
      'author': 'Dra. Ana López',
      'topic': 'Ansiedad y Estrés',
      'pdfPath': 'assets/pdfs/Gestionando_la_Ansiedad.pdf',
    },
    {
      'title': 'El Camino a la Resiliencia',
      'author': 'Dr. Carlos Ruiz',
      'topic': 'Autoestima y Resiliencia',
      'pdfPath': 'assets/pdfs/Camino_Resiliencia.pdf',
    },
    {
      'title': 'Mindfulness para el Día a Día',
      'author': 'Elena García',
      'topic': 'Relajación y Meditación',
      'pdfPath': 'assets/pdfs/Mindfulness_Diario.pdf',
    },
    {
      'title': 'Superando la Procrastinación',
      'author': 'Javier Montes',
      'topic': 'Productividad y Enfoque',
      'pdfPath': 'assets/pdfs/Superando_Procrastinacion.pdf',
    },
    {
      'title': 'Comunicación Asertiva',
      'author': 'María Soto',
      'topic': 'Relaciones Personales',
      'pdfPath': 'assets/pdfs/Comunicacion_Asertiva.pdf',
    },
    {
      'title': 'Viviendo sin Miedo',
      'author': 'Dra. Ana López',
      'topic': 'Ansiedad y Estrés',
      'pdfPath': 'assets/pdfs/Viviendo_sin_Miedo.pdf',
    },
    {
      'title': 'El Poder del Sí Mismo',
      'author': 'Dr. Carlos Ruiz',
      'topic': 'Autoestima y Resiliencia',
      'pdfPath': 'assets/pdfs/Poder_del_Si_Mismo.pdf',
    },
  ];

  // 📝 Lista de categorías únicas (tópicos)
  late final List<String> _topics;

  @override
  void initState() {
    super.initState();
    // Extraer tópicos únicos y añadir "Todos" al inicio
    _topics = [
      'Todos',
      // ignore: unnecessary_to_list_in_spreads
      ..._allBooks.map((book) => book['topic']!).toSet().toList(),
    ];

    // Escuchar cambios en la barra de búsqueda
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // 🔍 Función para actualizar la búsqueda
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // ⚙️ Función para filtrar y buscar libros
  List<Map<String, String>> get _filteredBooks {
    return _allBooks.where((book) {
      final matchesTopic =
          _selectedTopic == 'Todos' || book['topic'] == _selectedTopic;
      final matchesQuery =
          _searchQuery.isEmpty ||
          book['title']!.toLowerCase().contains(_searchQuery) ||
          book['author']!.toLowerCase().contains(_searchQuery);

      return matchesTopic && matchesQuery;
    }).toList();
  }

  // 1. ⚙️ Función para construir el Drawer
  Drawer _buildDrawer(BuildContext context) {
    // NOTA: En una aplicación real, el UserAuth debe obtenerse aquí también
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(currentUser?.email?.split("@")[0] ?? "Usuario"),
            accountEmail: Text(currentUser?.email ?? "Sin correo"),
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
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blueAccent),
            title: const Text("Inicio"),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.purple),
            title: const Text("Librería"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.toys_outlined, color: Colors.orange),
            title: const Text("Zona Anti-Estrés"),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/distraction-zone',
                ),
          ),
          ListTile(
            leading: const Icon(
              Icons.medical_services,
              color: Colors.redAccent,
            ),
            title: const Text("Recursos y Especialistas"),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/professional-help',
                ),
          ),
          const Divider(),
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

  // 2. 🔍 Widget de barra de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Buscar por título o autor...",
          prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  // 3. 🏷️ Widget de chips de categorías
  Widget _buildTopicChips() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          final isSelected = _selectedTopic == topic;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: FilterChip(
              label: Text(topic),
              selected: isSelected,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              selectedColor: Colors.blueAccent,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedTopic = selected ? topic : 'Todos';
                });
              },
            ),
          );
        },
      ),
    );
  }

  // 4. 📖 Widget para mostrar cada libro
  Widget _buildBookCard(Map<String, String> book) {
    // 🚀 Lógica de navegación: Lleva al usuario a la pantalla del visor
    void navigateToBookViewer() {
      // Usamos pushNamed y pasamos el objeto 'book' como argumento.
      Navigator.pushNamed(
        context,
        '/book-viewer',
        arguments: book, // Pasamos el mapa completo del libro.
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // Al tocar la tarjeta, navega al visor.
        onTap: navigateToBookViewer,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono/Simulación de Portada
              Container(
                width: 50,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: const Center(
                  child: Icon(Icons.book, size: 28, color: Colors.purple),
                ),
              ),
              const SizedBox(width: 16),
              // Detalles del libro y botón de acción
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1e88e5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Autor: ${book['author']!}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Botón de Ver o Descargar Libro
                    OutlinedButton.icon(
                      onPressed: navigateToBookViewer,
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text("Ver/Descargar Libro"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.teal,
                        side: const BorderSide(color: Colors.teal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. 🏗️ Estructura principal (Scaffold)
  @override
  Widget build(BuildContext context) {
    final booksToShow = _filteredBooks;

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text(
          "Librería de Autoayuda",
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
        child: Column(
          children: [
            _buildSearchBar(), // Barra de búsqueda
            _buildTopicChips(), // Chips de categorías
            const SizedBox(height: 10),

            // Lista de libros filtrada
            Expanded(
              child:
                  booksToShow.isEmpty
                      ? Center(
                        child: Text(
                          "No se encontraron libros para: \n'${_searchController.text}'",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: booksToShow.length,
                        itemBuilder: (context, index) {
                          return _buildBookCard(booksToShow[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
