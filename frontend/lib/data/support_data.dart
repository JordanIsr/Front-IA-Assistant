// Archivo: lib/data/support_data.dart
import 'package:flutter/material.dart';

// Esta es la lista que importaremos en tu Home
final List<Map<String, dynamic>> supportMenusData = [
  {
    'title': 'Pérdida de un ser querido',
    'icon': Icons.healing,
    'color': const Color(0xFF5D6D7E),
    'image': 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Navega por el duelo con compasión.',
    'longDescription': 'El duelo no es lineal y no tiene fecha de caducidad. Es el precio que pagamos por amar. En este espacio, te recordamos que está bien no estar bien.',
    'steps': [
      {'title': 'Siente sin juzgar', 'body': 'No reprimas el llanto ni la ira. Deja que las emociones fluyan como olas.'},
      {'title': 'Crea un ritual', 'body': 'Enciende una vela o escribe una carta para honrar su memoria.'},
      {'title': 'Busca tu red', 'body': 'No te aísles por completo. Habla con alguien que sepa escuchar.'},
    ],
    'links': [
      {'title': 'Video: Manejo del duelo', 'url': 'https://www.youtube.com/results?search_query=manejo+del+duelo+psicologia'},
      {'title': 'Artículo: Las 5 etapas', 'url': 'https://www.google.com/search?q=etapas+del+duelo'},
    ]
  },
  {
    'title': 'Ruptura amorosa',
    'icon': Icons.heart_broken,
    'color': const Color(0xFFEC7063),
    'image': 'https://images.unsplash.com/photo-1516585427167-9f4af9627e6c?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Sana tu corazón y reencuéntrate.',
    'longDescription': 'Una ruptura es una herida emocional profunda. Es el momento de volver a enamorarte de la persona más importante de tu vida: tú mismo.',
    'steps': [
      {'title': 'Contacto Cero', 'body': 'Es vital para desintoxicarte emocionalmente. Bloquea si es necesario.'},
      {'title': 'Redescubre hobbies', 'body': '¿Qué te gustaba hacer antes de la relación? Retómalo hoy.'},
      {'title': 'Evita la idealización', 'body': 'Haz una lista objetiva de por qué la relación no funcionaba.'},
    ],
    'links': [
      {'title': 'Video: Corazón roto', 'url': 'https://www.youtube.com/results?search_query=sanar+corazon+roto+psicologia'},
    ]
  },
  {
    'title': 'Estrés laboral',
    'icon': Icons.work,
    'color': const Color(0xFFF4D03F),
    'image': 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Maneja el agotamiento y pon límites.',
    'longDescription': 'El burnout no es un trofeo de éxito. Tu salud mental es más importante que cualquier fecha de entrega.',
    'steps': [
      {'title': 'Límites claros', 'body': 'No revises correos fuera de tu horario. Desactiva notificaciones.'},
      {'title': 'Técnica Pomodoro', 'body': 'Trabaja 25 minutos, descansa 5. Tu cerebro necesita pausas.'},
      {'title': 'Micro-descansos', 'body': 'Levántate, estira las piernas y bebe agua cada hora.'},
    ],
    'links': [
      {'title': 'Música concentración', 'url': 'https://www.youtube.com/results?search_query=lofi+hip+hop+radio'},
    ]
  },
  {
    'title': 'Ansiedad y preocupación',
    'icon': Icons.cloud_queue,
    'color': const Color(0xFF58D683),
    'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Técnicas para calmar tu mente.',
    'longDescription': 'La ansiedad es exceso de futuro. Vamos a traer tu mente de vuelta al "ahora" con técnicas somáticas y respiración.',
    'steps': [
      {'title': 'Respiración 4-7-8', 'body': 'Inhala en 4, mantén 7, exhala en 8. Repite 4 veces.'},
      {'title': 'Grounding 5-4-3-2-1', 'body': 'Nombra 5 cosas que ves, 4 que tocas, 3 que oyes, 2 que hueles, 1 que saboreas.'},
      {'title': 'Escribe', 'body': 'Saca los pensamientos de tu cabeza y ponlos en papel.'},
    ],
    'links': [
      {'title': 'Meditación guiada', 'url': 'https://www.youtube.com/results?search_query=meditacion+guiada+ansiedad'},
    ]
  },
  {
    'title': 'Metas y motivación',
    'icon': Icons.rocket_launch,
    'color': Colors.deepPurple,
    'image': 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Planifica y alcanza tus sueños.',
    'longDescription': 'La motivación es lo que te hace empezar, el hábito es lo que te mantiene. Construyamos disciplina paso a paso.',
    'steps': [
      {'title': 'Metas SMART', 'body': 'Que sean Específicas, Medibles, Alcanzables, Relevantes y con Tiempo.'},
      {'title': 'Divide y vencerás', 'body': 'Rompe una gran meta en tareas de 15 minutos.'},
      {'title': 'Visualiza', 'body': 'Imagina cómo te sentirás al lograrlo, no solo el resultado.'},
    ],
    'links': [
      {'title': 'Videos Motivación', 'url': 'https://www.youtube.com/results?search_query=motivacion+personal'},
    ]
  },
  {
    'title': 'Dificultad para dormir',
    'icon': Icons.nightlight_round,
    'color': const Color(0xFF3498DB),
    'image': 'https://images.unsplash.com/photo-1511295742362-92c96b5add36?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Higiene del sueño para descansar.',
    'longDescription': 'Dormir es el pilar de la salud mental. Una mente cansada no puede gestionar emociones correctamente.',
    'steps': [
      {'title': 'Cero pantallas', 'body': 'Deja el celular 1 hora antes. La luz azul bloquea la melatonina.'},
      {'title': 'Ruido Blanco', 'body': 'Prueba sonidos de lluvia o ventilador para bloquear ruidos externos.'},
      {'title': 'Escaneo corporal', 'body': 'Relaja cada músculo desde los pies hasta la cabeza.'},
    ],
    'links': [
      {'title': 'Música para dormir', 'url': 'https://www.youtube.com/results?search_query=musica+para+dormir+profundamente'},
    ]
  },
  {
    'title': 'Manejo de la ira',
    'icon': Icons.flash_on,
    'color': const Color(0xFFCD6155),
    'image': 'https://images.unsplash.com/photo-1542259659483-424a7d653839?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Canaliza la energía explosiva.',
    'longDescription': 'La ira es una emoción válida que nos dice que algo es injusto. El problema no es sentirla, es cómo reaccionamos ante ella.',
    'steps': [
      {'title': 'Tiempo fuera', 'body': 'Si sientes calor en la cara, retírate de la situación 5 minutos.'},
      {'title': 'Descarga física', 'body': 'Haz ejercicio intenso, golpea una almohada o grita en un cojín.'},
      {'title': 'Escribe la carta', 'body': 'Escribe todo lo que piensas sin filtro en una carta y luego destrúyela.'},
    ],
    'links': [
      {'title': 'Control de la ira', 'url': 'https://www.youtube.com/results?search_query=control+de+la+ira+tecnicas'},
    ]
  },
  {
    'title': 'Soledad',
    'icon': Icons.people_outline,
    'color': const Color(0xFF9B59B6),
    'image': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?q=80&w=2000&auto=format&fit=crop',
    'shortDescription': 'Reconecta contigo y con otros.',
    'longDescription': 'Estar solo no es lo mismo que sentirse solo. Puedes aprender a disfrutar tu compañía mientras construyes puentes hacia los demás.',
    'steps': [
      {'title': 'Voluntariado', 'body': 'Ayudar a otros es la forma más rápida de sentirse conectado.'},
      {'title': 'Pequeñas interacciones', 'body': 'Saluda al cajero o al vecino. Rompe la burbuja.'},
      {'title': 'Clubes de interés', 'body': 'Únete a grupos de lectura, deporte o arte.'},
    ],
    'links': [
      {'title': 'Vencer la soledad', 'url': 'https://www.youtube.com/results?search_query=como+vencer+la+soledad'},
    ]
  },
];