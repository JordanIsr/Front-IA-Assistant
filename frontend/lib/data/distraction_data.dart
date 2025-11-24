import 'package:flutter/material.dart';

final List<Map<String, dynamic>> distractionActivities = [
  {
    'id': 'breathing',
    'title': 'Ejercicios de Calma',
    'subtitle': 'Respiración guiada para reducir la ansiedad.',
    'icon': Icons.self_improvement,
    'color': Colors.green.shade600,
    'description': 'La respiración consciente es la herramienta más rápida para calmar el sistema nervioso. Utiliza esta técnica cuando sientas pánico o estrés agudo.',
    'instructions': [
      'Siéntate en una posición cómoda con la espalda recta.',
      'Inhala profundamente por la nariz contando hasta 4.',
      'Retén el aire en tus pulmones contando hasta 7.',
      'Exhala suavemente por la boca contando hasta 8.',
      'Repite este ciclo 4 veces.'
    ]
  },
  {
    'id': 'sounds',
    'title': 'Sonidos Relajantes',
    'subtitle': 'Ruido blanco, lluvia, bosque.',
    'icon': Icons.spa,
    'color': Colors.teal.shade600,
    'description': 'Los sonidos de la naturaleza ayudan a reducir la frecuencia cardíaca y mejoran la concentración al bloquear ruidos molestos del ambiente.',
    'instructions': [
      'Usa audífonos para una mejor experiencia.',
      'Cierra los ojos e imagina que estás en el lugar del sonido.',
      'Concéntrate únicamente en lo que escuchas.',
      'Deja que el sonido limpie tus pensamientos.'
    ]
  },
  {
    'id': 'games',
    'title': 'Minijuegos Rápidos',
    'subtitle': 'Juegos sencillos que no requieren esfuerzo.',
    'icon': Icons.videogame_asset_outlined,
    'color': Colors.orange.shade600,
    'description': 'A veces el cerebro necesita un "reinicio". Estos juegos repetitivos y simples ayudan a romper el bucle de pensamientos obsesivos.',
    'instructions': [
      'El objetivo no es ganar, es distraerse.',
      'Juega durante 5 minutos cuando sientas mucha rumiación mental.',
      'Enfócate en los colores y movimientos del juego.'
    ]
  },
  {
    'id': 'journal',
    'title': 'Diario Emocional',
    'subtitle': 'Escribe tus pensamientos para liberarlos.',
    'icon': Icons.edit_note,
    'color': Colors.blueGrey.shade600,
    'description': 'Escribir es una terapia poderosa. Al poner palabras a tus sentimientos, les quitas poder sobre ti y ganas claridad.',
    'instructions': [
      'No te preocupes por la ortografía o el orden.',
      'Escribe exactamente cómo te sientes ahora mismo.',
      'Pregúntate: "¿Por qué me siento así?" y "¿Qué puedo hacer ahora?"',
      'Al terminar, respira hondo y cierra el capítulo.'
    ]
  },
];