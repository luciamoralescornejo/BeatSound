import 'package:beatsound_app/auth_pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BeatSoundApp());
}

//define la configuración global de la app
class BeatSoundApp extends StatelessWidget {
  const BeatSoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //quita la etiqueta roja de debug de la esquina por defecto
      title: 'BeatSound',

      //configutación visual de toda la app
      theme: ThemeData(
        brightness: Brightness.dark, //por defecto tendrá el modo oscuro
        scaffoldBackgroundColor: Colors.black, //el fondo de la pantalla es negro
        primaryColor: const Color(0xFF2962FF), //el primario es un azul electrico que hace constraste con el negro
        iconTheme: const IconThemeData(color: Colors.white), //los iconos blancos
      ),

      //aqui se define cuál es la primera pantalla que se muestra al abrir la app
      home: const PantallaLogin(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  //crea el estado, el encargado de guardar los datos cambiantes
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

//este es el estado, tiene la lógica de la pantalla principal
class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0; //variable para conocer qué pestaña esta seleccionada en el menu

  //lista de pestañas (inicio, novedades o perfil)
  final List<Widget> _paginas = [
    const Scaffold(body: Center(child: Text('Inicio', style: TextStyle(color: Colors.white)))),
    const Scaffold(body: Center(child: Text('Novedades', style: TextStyle(color: Colors.white)))),
    const Scaffold(body: Center(child: Text('Perfil', style: TextStyle(color: Colors.white)))),
  ];

  @override
  Widget build(BuildContext context) {

    //scaffold muestra la estructura básica de cualquier pantalla de flutter
    return Scaffold(
      backgroundColor: Colors.black,

      //muestra la página según el num que guarde la variable
      body: _paginas[_indiceActual],

      //barra de navegación de abajo
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //los iconos estan fijados
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF2962FF), //cuando se selecciona, el icono y la letra es azul
        unselectedItemColor: Colors.white60, //gris cuando está sin seleccionar
        currentIndex: _indiceActual, //le dice a la barra qué icono poner en azul
        showUnselectedLabels: false, //oculta el texto de debajo del icono si no esta seleccionado

        //funcion que se ejecuta cuando el usuario pulsa un icono
        onTap: (index) =>
        //setState es vital para avisar a flutter del cambio de variabe
        setState(() => _indiceActual = index),

        //botones de la barra inferior
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Novedades'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}