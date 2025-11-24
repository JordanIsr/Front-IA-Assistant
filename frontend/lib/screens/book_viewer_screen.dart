import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Cambiamos a StatefulWidget para gestionar el estado de carga y errores
class BookViewerScreen extends StatefulWidget {
  const BookViewerScreen({super.key});

  @override
  State<BookViewerScreen> createState() => _BookViewerScreenState();
}

class _BookViewerScreenState extends State<BookViewerScreen> {
  // 1. Controlador del PDF Viewer
  late PdfViewerController _pdfViewerController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  // 🔎 NOTA: Se ha eliminado la función _startSearch y el botón de búsqueda
  // debido a que la sintaxis para abrir la barra de búsqueda nativa
  // (textSearch.search() o search()) no es compatible con la versión actual
  // del paquete syncfusion_flutter_pdfviewer (^26.2.4).
  // Esto asegura que el código compile correctamente.

  @override
  Widget build(BuildContext context) {
    final book =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    if (book == null || book['pdfPath'] == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error de Archivo")),
        body: const Center(child: Text("Ruta del PDF no encontrada.")),
      );
    }

    final String pdfPath = book['pdfPath']!;
    final String title = book['title'] ?? 'Libro Desconocido';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xff1e88e5),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              // Simular descarga o guardar acción
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              // Zoom in (usando el controlador)
              _pdfViewerController.zoomLevel =
                  _pdfViewerController.zoomLevel + 0.25;
            },
          ),
          // 🛑 Botón de búsqueda eliminado para evitar el error 'undefined_getter'
          // Puedes volver a agregarlo si actualizas el paquete PDF o implementas
          // tu propia barra de búsqueda de Flutter.
        ],
      ),

      // 🚀 Visor de PDF con manejo de carga y errores
      body: Stack(
        children: [
          SfPdfViewer.asset(
            pdfPath,
            controller: _pdfViewerController,
            // Cuando el documento se carga correctamente
            onDocumentLoaded: (details) {
              setState(() {
                _isLoading = false;
                _errorMessage = null;
              });
              debugPrint('✅ PDF cargado correctamente: $pdfPath');
            },
            // Cuando el documento falla al cargar
            onDocumentLoadFailed: (details) {
              setState(() {
                _isLoading = false;
                _errorMessage =
                    'Error al cargar el PDF. Asegúrate de que la ruta del asset sea correcta. Detalles: ${details.description}';
              });
              debugPrint(
                '❌ Error al cargar el PDF: $pdfPath. Detalles: ${details.description}',
              );
            },
          ),

          // Muestra un indicador de carga o el mensaje de error
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xff1e88e5)),
                  SizedBox(height: 16),
                  Text("Cargando libro...", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

          if (_errorMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Error de visualización',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Verifica que el archivo PDF esté en la carpeta "assets/pdfs/" y que su nombre coincida exactamente con el código.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
