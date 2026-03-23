import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; //librería externa para que el video funcione
import 'dart:io'; //para poder leer archivos de video guardados en el movil

//recibe la ruta del video, el nombre del artista y el estilo.
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

  //se ejecuta una sola vez cuando aparece el video
  @override
  void initState() {
    super.initState();
    _inicializarVideo(); //llamamos a nuestra función para preparar el video
  }

  //preparamos el video
  void _inicializarVideo() {
    //es un video que está guardado en los archivos del teléfono
    _controller = VideoPlayerController.file(File(widget.rutaArchivo));

    //una vez que el video se carga (initialize)
    _controller.initialize().then((_) {
      setState(() {}); //refrescamos para quitar el icono de carga y mostrar el video
      _controller.play(); //empezar a reproducir
      _controller.setLooping(true); //cuando termine, que empiece otra vez (bucle)
    });
  }

  //muy importante, cuando pasamos al siguiente video, "apagamos" el controlador viejo para que
  // no gaste memoria ni batería en segundo plano
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack( //stack para poner el video al fondo y las letras encima
      fit: StackFit.expand,
      children: [
        //si el video ya está listo, lo mostramos,si no, mostramos un círculo de carga
        _controller.value.isInitialized
            ? Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio, //mantiene la forma original del video
            child: VideoPlayer(_controller),
          ),
        )
            : const Center(child: CircularProgressIndicator(color: Color(0xFF2962FF))),

        _construirGradiente(), //ponemos una sombra oscura para que las letras blancas se lean bien
        _construirInterfaz(), //dibujamos el texto y el botón de like
      ],
    );
  }

  //crea un degradado negro arriba y abajo para mejorar la visibilidad
  Widget _construirGradiente() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            Colors.black.withOpacity(0.4), //sombra suave arriba
            Colors.transparent, //centro claro para ver el video
            Colors.black.withOpacity(0.9), //sombra fuerte abajo para los textos
          ],
        ),
      ),
    );
  }

  //textos y botones
  Widget _construirInterfaz() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, //empuja hacia la parte inferior
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //columna de la izquierda: nombre y estilo.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.artista.toUpperCase(), //nombre del artista en mayúsculas
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      //etiqueta del estilo con fondo azulito
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2962FF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: const Color(0xFF2962FF).withOpacity(0.4)),
                        ),
                        child: Text("#${widget.estilo.toUpperCase()}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                //columna de la derecha, el botón de like
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      //al tocar el corazón, cambiamos el estado de _dioLike
                      onTap: () => setState(() => _dioLike = !_dioLike),
                      child: Icon(
                        _dioLike ? Icons.favorite : Icons.favorite_border_rounded, //corazón lleno o vacío
                        color: _dioLike ? Colors.redAccent : Colors.white, //rojo si dio like, blanco si no
                        size: 45,
                        shadows: _dioLike ? [const Shadow(color: Colors.red, blurRadius: 20)] : null, //brillo rojo
                      ),
                    ),
                    const SizedBox(height: 5),
                    //simulación de contador, sube 1 si das like
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
}