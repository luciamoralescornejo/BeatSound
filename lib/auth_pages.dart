import 'package:flutter/material.dart';
import 'main.dart'; //hay que importar el archivo principal para navegar entre archivos

//función para ir de una pantalla a otra sin ninguna animación
void _navegarInstantaneo(BuildContext context, Widget destino, {bool reemplazar = false}) {
  final route = PageRouteBuilder(
    pageBuilder: (context, animacion, animacionSecundaria) => destino,
    transitionDuration: Duration.zero, //la duración de entrada de la nueva ventana es 0 segundos
    reverseTransitionDuration: Duration.zero, //la duración de salida es de 0 segundos
    transitionsBuilder: (context, animacion, animacionSecundaria, child) => child,
  );
  if (reemplazar) {
    //con Navigator.pushReplacement reemplazamos la pantalla anterior pisandola
    Navigator.pushReplacement(context, route);
  } else {
    //ponemos la pantalla nueva encima d ela otra
    Navigator.push(context, route);
  }
}

//metodo para contruir la cabecera con el logo y su título encima
Widget _cabeceraConImagen(String rutaImagenTitulo) {
  return Container(
    height: 250,
    width: double.infinity,
    alignment: Alignment.center,
    child: Stack( //con esto permite poner una imagen encima de otra
      alignment: Alignment.center,
      children: [
        Hero( //animación fluida de una imagen
          tag: 'logo_principal',
          child: Image.asset("assets/logo.png", width: 250, height: 250, fit: BoxFit.contain),
        ),
        Positioned( //pone el título encima del logo
          bottom: 78,
          child: Hero(
            tag: 'titulo_auth',
            child: Image.asset(rutaImagenTitulo, width: 255, fit: BoxFit.contain),
          ),
        ),
      ],
    ),
  );
}

//crea el fondo con la imagen de manera que ocupa el fondo completo
Widget _crearFondo() {
  return SizedBox.expand(
    child: Image.asset(
      "assets/Fondo.png",
      fit: BoxFit.cover, //la imagen ocupa toda la pantalla SIN DEFORMARSE
      //en caso de que la imagen falle el fondo se ve negro y ya
      errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
    ),
  );
}

// --- INICIAR SESIÓN ---
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _EstadoPantallaLogin();
}

class _EstadoPantallaLogin extends State<PantallaLogin> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //precarga las imagenes para que cuando haya que mostrarlas no hay aparpadeos
    precacheImage(const AssetImage("assets/IniciarSesion.png"), context);
    precacheImage(const AssetImage("assets/Registrarse.png"), context);
    precacheImage(const AssetImage("assets/logo.png"), context);
    precacheImage(const AssetImage("assets/Fondo.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack( //stack para que el fondo se quede atrás y el contenido delante
        children: [
          _crearFondo(), //imagen de fondo
          SafeArea( //capa de delante con el contenido evitando que toque la camara delantera
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _cabeceraConImagen("assets/IniciarSesion.png"),
                    const SizedBox(height: 20),
                    //contenedor del formulario
                    _crearContenedorFormulario([
                      _crearCampoTexto("Correo electrónico"),
                      const SizedBox(height: 15),
                      _crearCampoTexto("Contraseña", isPassword: true),
                    ]),
                    const SizedBox(height: 40),
                    //botón para entrar
                    _crearBoton("INICIAR SESIÓN", const Color(0xFF4D6CFF), () {
                      _navegarInstantaneo(context, const PantallaPrincipal(), reemplazar: true);
                    }),
                    //botón para registrarse
                    const SizedBox(height: 15),
                    _crearBoton("REGISTRARSE", const Color(0xFF4D6CFF), () {
                      _navegarInstantaneo(context, const RegistroPaso1());
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA DE REGISTRO ---
class RegistroPaso1 extends StatefulWidget {
  const RegistroPaso1({super.key});

  @override
  State<RegistroPaso1> createState() => _RegistroPaso1State();
}

class _RegistroPaso1State extends State<RegistroPaso1> {
  //variable para saber si el usuario es oyente o artista
  bool esArtista = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _crearFondo(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _cabeceraConImagen("assets/Registrarse.png"),
                  const SizedBox(height: 20),
                  _crearContenedorFormulario([
                    _crearCampoTexto("Correo electrónico"),
                    const SizedBox(height: 15),
                    _crearCampoTexto("Contraseña", isPassword: true),
                    const SizedBox(height: 15),
                    _crearCampoTexto("Confirmar contraseña", isPassword: true),
                    const SizedBox(height: 25),
                    //fila para elegir rol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _cearBotonRol(Icons.headphones, "Oyente", !esArtista, () => setState(() => esArtista = false)),
                        _cearBotonRol(Icons.mic, "Artista", esArtista, () => setState(() => esArtista = true)),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 40),
                    _crearBoton("SIGUIENTE", const Color(0xFF4D6CFF), () {
                      if (esArtista) {
                        _navegarInstantaneo(context, const RegistroArtistaDatos());
                      } else {
                        _navegarInstantaneo(context, const RegistroAvatarOyente());
                      }
                    }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //metodo para crear el botón de elección de rol
  Widget _cearBotonRol(IconData icono, String titulo, bool seleccionado, VoidCallback alPulsar) {
    return GestureDetector(
      onTap: alPulsar,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: seleccionado ? Colors.white10 : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icono, color: seleccionado ? const Color(0xFF2962FF) : Colors.grey, size: 30),
            Text(titulo, style: TextStyle(color: seleccionado ? Colors.white : Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// --- ELEGIR AVATAR ---
class RegistroAvatarOyente extends StatefulWidget {
  const RegistroAvatarOyente({super.key});

  @override
  State<RegistroAvatarOyente> createState() => _RegistroAvatarOyenteState();
}

class _RegistroAvatarOyenteState extends State<RegistroAvatarOyente> {

  //lista de avatares
  final List<String> _avatares = List.generate(10, (i) => "assets/avatares/avatar${i + 1}.png");
  int _indiceActual = 0; //variable para saber el avatar seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _crearFondo(), //mismo fondo
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _cabeceraConImagen("assets/Registrarse.png"), //usa el mismo header pero diferente texto
                    const SizedBox(height: 20),
                    const Text(
                      "ELIJA UN AVATAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //selector de avatar (caja gris oscura)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF262626).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //botón de la izquierda, retrocede la lista
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            // si estamos en el 0 y restamos 1 volvemos al último
                            onPressed: () => setState(() => _indiceActual = (_indiceActual - 1 + _avatares.length) % _avatares.length),
                          ),

                          //contenedor del avatar (circulo azul)
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, //hace que el borde se vea circular
                              border: Border.all(color: const Color(0xFF2962FF), width: 3),
                              boxShadow: [
                                //efecto neon
                                BoxShadow(color: const Color(0xFF2962FF).withOpacity(0.4), blurRadius: 40, spreadRadius: 2),
                              ],
                            ),
                            child: ClipOval(
                              //ClipOval corta la imagen para que encaje en elcirculo
                              child: Image.asset(_avatares[_indiceActual], fit: BoxFit.cover),
                            ),
                          ),

                          //botón de la derecha, avanza la lista
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            onPressed: () => setState(() =>
                            //si llegamos al final y sumamos 1, la lista vuelve al principio
                            _indiceActual = (_indiceActual + 1) % _avatares.length),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    //botón de finalizar el registro
                    _crearBoton("REGISTRARSE", const Color(0xFF4D6CFF), () {
                      //popUntil limpia las pantallas y vuelve a la primera
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//metodo para registrar los artsitas
class RegistroArtistaDatos extends StatelessWidget {
  const RegistroArtistaDatos({super.key});

  @override
  Widget build(BuildContext context) {
    //scaffold=lienzo de la pantalla en blanco
    return Scaffold(
      backgroundColor: Colors.black,//fondo negro
      //con stack ponemos capas
      body: Stack(
        children: [
          //primera capa, la imagen de fondo
          _crearFondo(),
          //segunda capa, el contenido
          SafeArea(
            //con esto el usuario puede hacer srcoll si el contenido es muy largo
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30), //margen
              //organiza los elementos en columna
              child: Column(
                children: [
                  const SizedBox(height: 40), //espacio de 40px
                  _cabeceraConImagen("assets/Registrarse.png"), //imagen de registro sobre la cabecera
                  const SizedBox(height: 30), //espacio
                  //formulario completo
                  _crearContenedorFormulario([
                    _crearCampoTexto("Nombre artístico"),
                    const SizedBox(height: 12),
                    _crearCampoTexto("Descripción"),
                    const SizedBox(height: 12),
                    _crearCampoTexto("URL Spotify"),
                    const SizedBox(height: 12),
                    _crearCampoTexto("URL Instagram"),
                    const SizedBox(height: 12),
                    _crearCampoTexto("URL Tiktok"),
                  ]),
                  const SizedBox(height: 40), //espacio
                  _crearBoton("REGISTRARSE", const Color(0xFF4D6CFF), () { //botón
                    //con esta línea se vuelve a la primera página y se cierran el resto
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

//contenedor oscuro con los campos del formulario
Widget _crearContenedorFormulario(List<Widget> children) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF262626).withOpacity(0.85),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white10),
    ),
    child: Column(children: children),
  );
}

//campos de texto con su estilo redondeado y gris
Widget _crearCampoTexto(String hint, {bool isPassword = false}) {
  return TextField(
    obscureText: isPassword, //en caso de true el texto sale oculto
    style: const TextStyle(color: Colors.white, fontSize: 14),
    decoration: InputDecoration(
      hintText: hint, //texto de sugerencia
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF444444).withOpacity(0.7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
    ),
  );
}

//botones grandes y azules
Widget _crearBoton(String texto, Color color, VoidCallback alPulsar) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: alPulsar,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      ),
      child: Text(texto, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
    ),
  );
}