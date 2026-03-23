import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; //librería externa para que el video funcione
import 'dart:io'; //para poder leer archivos de video guardados en el movil
import 'dart:ui'; //permite usar filtros de imagen como el desenfoque

class VideoCard extends StatefulWidget {
  final String rutaArchivo;
  final String artista;
  final String estilo;

  const VideoCard({
    super.key,
    required this.rutaArchivo,
    required this.artista,
    required this.estilo,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  //el controlador es pausar, play...
  late VideoPlayerController _controller;
  //variable para saber si el usuario tocó el corazón de like
  bool _dioLike = false;

  //guarda cuánto estamos moviendo el video hacia los lados
  double _offsetHorizontal = 0.0;

  //se ejecuta una sola vez cuando aparece el video
  @override
  void initState() {
    super.initState();
    //el video es del móvil
      _controller = VideoPlayerController.file(File(widget.rutaArchivo));

    //una vez que el video se carga (initialize)
    _controller.initialize().then((_) {
      setState(() {}); //refrescamos para quitar el icono de carga y mostrar el video
      _controller.play(); //empezar a reproducir
      _controller.setLooping(true); //cuando termine, que empiece otra vez (bucle)
    });
  }

  //muy importante, "apagamos" el controlador viejo para ahorrar memoria
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //crea las opciones dentro del menú (como bloquear artista)
  Widget _buildOptionTile(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context); //cierra el menú
        _mostrarToastRapido("Acción: $title"); //muestra un aviso de confirmación
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //cuando el usuario arrastra el dedo por la pantalla
      onHorizontalDragUpdate: (details) {
        //actualizamos el movimiento horizontal según movamos el dedo
        setState(() => _offsetHorizontal += details.delta.dx);
      },
      //cuando el usuario suelta el dedo de la pantalla
      onHorizontalDragEnd: (details) {
        if (_offsetHorizontal > 100) {
          _mostrarToastRapido("Siguiendo a ${widget.artista}");
        } else if (_offsetHorizontal < -100) {
          _mostrarToastRapido("Menos contenido de #${widget.estilo}");
        }
        //al soltar, el video vuelve a su posición central (0.0)
        setState(() => _offsetHorizontal = 0.0);
      },
      //atajo: doble toque para dar like automáticamente
      onDoubleTap: () => setState(() => _dioLike = true),

      child: Stack(
        children: [
          //muestra los iconos de seguir o menos que se ven al arrastrar
          _construirFondoAcciones(),

          //el video tiene animación para que se mueva suavemente
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            //aquí es donde el video se desplaza físicamente a la izquierda o derecha
            transform: Matrix4.translationValues(_offsetHorizontal, 0, 0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                //si el video ya está listo, lo mostramos, si no, círculo de carga
                _controller.value.isInitialized
                    ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )
                    : const Center(child: CircularProgressIndicator(color: Color(0xFF2962FF))),

                _construirGradienteBeatsound(), //sombra oscura para leer bien las letras
                _construirInterfaz(context), //dibujamos textos, like y el nuevo botón de opciones
              ],
            ),
          ),
        ],
      ),
    );
  }

  //dibuja lo que hay detrás del video (los avisos de seguir/borrar)
  Widget _construirFondoAcciones() {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionHint(Icons.person_add_alt_1, "SEGUIR", const Color(0xFF2962FF), _offsetHorizontal > 20),
          _buildActionHint(Icons.heart_broken_rounded, "MENOS", Colors.redAccent, _offsetHorizontal < -20),
        ],
      ),
    );
  }

  //crea el icono y texto que aparecen al deslizar
  Widget _buildActionHint(IconData icon, String label, Color color, bool visible) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Opacity(
        opacity: visible ? 1.0 : 0.0, //solo aparece si estamos deslizando suficiente
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 50),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }

  //mantiene la sombra oscura arriba y abajo
  Widget _construirGradienteBeatsound() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.transparent,
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
    );
  }

  //textos, botones y el botón de más opciones
  Widget _construirInterfaz(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //separa arriba y abajo
          children: [
            //botón de tres puntos para abrir el menú
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => _mostrarMenuOpciones(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Icon(Icons.more_horiz, color: Colors.white, size: 28),
                ),
              ),
            ),

            //nombre del artista y like
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.artista.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2962FF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: const Color(0xFF2962FF).withOpacity(0.4)),
                        ),
                        child: Text("#${widget.estilo.toUpperCase()}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _dioLike = !_dioLike),
                      child: Icon(
                        _dioLike ? Icons.favorite : Icons.favorite_border_rounded,
                        color: _dioLike ? Colors.redAccent : Colors.white,
                        size: 45,
                        shadows: _dioLike ? [const Shadow(color: Colors.red, blurRadius: 20)] : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _dioLike ? "1.201" : "1.200",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //crea la ventana flotante con el efecto de cristal desenfocado
  void _mostrarMenuOpciones(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => BackdropFilter(
        //efecto de desenfoque para el fondo del menú
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 45),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("OPCIONES", style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 14)),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.white10, thickness: 1),
                  _buildOptionTile(Icons.block_flipped, "Bloquear Artista", Colors.redAccent),
                  const Divider(color: Colors.white10, thickness: 1),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCELAR", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //muestra un pequeño mensaje flotante en la parte inferior
  void _mostrarToastRapido(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating, //hace que flote sobre el contenido
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}