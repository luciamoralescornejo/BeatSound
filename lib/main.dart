import 'package:flutter/material.dart';
import 'auth_pages.dart';
import 'video_card.dart';
import 'novedades.dart';

void main() {
  runApp(const BeatSoundApp());
}

//configuración global
class BeatSoundApp extends StatelessWidget {
  const BeatSoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //quita la barra debug
      title: 'BeatSound',
      theme: ThemeData(
        brightness: Brightness.dark, //modo oscuro
        scaffoldBackgroundColor: Colors.black, //fondo negro
        primaryColor: const Color(0xFF2962FF), //el color primario es el azul
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      //la app empieza con la pantalla de login
      home: const PantallaLogin(),
    );
  }
}

//pantalla principal
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  //variable para saber en qué pestaña del menú de abajo estamos
  int _indiceActual = 0;

  //esto es como la "base de datos"
  final List<Map<String, String>> videosPrueba = [
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-girl-dancing-at-a-party-with-neon-lights-42502-large.mp4",
      "artista": "Yyy891",
      "estilo": "Trap"
    },
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-man-dancing-under-a-street-light-at-night-42517-large.mp4",
      "artista": "Galle",
      "estilo": "Reggaeton"
    },
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-hands-of-a-dj-playing-music-at-a-party-42533-large.mp4",
      "artista": "GlorySixVain",
      "estilo": "Trap"
    },
  ];

  @override
  Widget build(BuildContext context) {
    //definición de las páginas
    final List<Widget> paginas = [
      //primera pagina, el inicio
      PageView.builder(
        scrollDirection: Axis.vertical, //el sroll hacia arriba y abajo como tiktok
        itemCount: videosPrueba.length, //de momento, los tres videos de la bd
        itemBuilder: (context, index) => VideoCard(
          // por cada vídeo se crea una tarjeta
          rutaArchivo: videosPrueba[index]["url"]!,
          artista: videosPrueba[index]["artista"]!,
          estilo: videosPrueba[index]["estilo"]!,
        ),
      ),
      //segunda pagina, el perfil de novedades
      const PantallaNovedades(),
      //tercera pagina, el perfil
      const Scaffold(body: Center(child: Text('Perfil', style: TextStyle(color: Colors.white)))),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      //se muestra la página que indica el menú de abajo
      body: paginas[_indiceActual],

      //menu de navegacion
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF2962FF),
        unselectedItemColor: Colors.white60,
        currentIndex: _indiceActual, //marca el icono actual como encendido
        showUnselectedLabels: false, //no muestra el texto cuando no esta encendido
        //al tocar un cono, actualiza el estado pa el cambioi de pagina
        onTap: (index) => setState(() => _indiceActual = index),
        //cada apartado del menu
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Novedades'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}