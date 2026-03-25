import 'package:flutter/material.dart';
//una herramienta para poder elegir videos del móvil
import 'package:image_picker/image_picker.dart';
//esto sirve para manejar archivos (como el video que elijamos)
import 'dart:io';

//es un StatefulWidget porque la pantalla va a cambiar (por ejemplo, cuando elijamos un video,
// queremos que se vea que ya está cargado)
class PublicarVideo extends StatefulWidget {
  const PublicarVideo({super.key});

  @override
  State<PublicarVideo> createState() => _PublicarVideoState();
}

class _PublicarVideoState extends State<PublicarVideo> {
  //aquí guardaremos el video que elija el usuario, al principio está vacío
  File? _videoSeleccionado;

  //este es el ayudante que abre la galería del móvil
  final ImagePicker _picker = ImagePicker();

  //estas cajitas guardan lo que el usuario escriba en los textos
  final TextEditingController _artistaController = TextEditingController();
  final TextEditingController _estiloController = TextEditingController();

  //esta función es la que hace el trabajo de abrir la galería y pedir el video
  Future<void> _seleccionarVideo() async {
    //le decimos al ayudante que busque el vídeo en la galería
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    //si el usuario sí eligió algo
    if (video != null) {
      //usamos setState para decirle a la app que ya tenemos video y hay que dibujar la ventana otra vez
      setState(() {
        _videoSeleccionado = File(video.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //el Scaffold es como el lienzo en blanco de nuestra pantalla
    return Scaffold(
      backgroundColor: Colors.black, //fondo negro
      body: Stack( //usamos Stack para poner cosas una encima de otra
        children: [
          _buildBackground(), //el fondo de pantalla
          SafeArea( //el contenido (con cuidado de no tapar la batería o el reloj del móvil)
            child: SingleChildScrollView( //para que si hay muchas cosas, podamos hacer scroll hacia abajo
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30), //margen a los lados
                child: Column( //ponemos los elementos uno debajo de otro
                  children: [
                    const SizedBox(height: 20), //un espacio vacío para separar
                    _buildHeaderSimple(), //el logo de la app
                    const SizedBox(height: 10),

                    //este es el botón grande para subir el video
                    GestureDetector(
                      onTap: _seleccionarVideo, //cuando lo tocas, se abre la galería
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF262626).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            //si no hay video, el borde es casi invisible. Si hay, se pone azul
                            color: _videoSeleccionado == null
                                ? Colors.white10
                                : const Color(0xFF2962FF),
                            width: 2,
                          ),
                        ),
                        //si NO hay video, enseñamos el icono de la nube
                        //si SÍ hay video, enseñamos un check de cagando
                        child: _videoSeleccionado == null
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined, color: Color(0xFF4D6CFF), size: 50),
                            SizedBox(height: 10),
                            Text("SUBIR VÍDEO", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                          ],
                        )
                            : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF2962FF), size: 60),
                            SizedBox(height: 10),
                            Text("VÍDEO CARGADO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    //aquí dibujamos la cajita para escribir el género musical
                    _buildFormContainer([
                      _buildTextField("Género Musical", controller: _estiloController),
                    ]),

                    const SizedBox(height: 40),

                    //el botón final de publicar
                    _buildButton("PUBLICAR EN BEATSOUND", const Color(0xFF4D6CFF), () {
                      //si el usuario eligió video, sale un mensaje de éxito
                      if (_videoSeleccionado != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("¡Publicando en Beatsound!")),
                        );
                        Navigator.pop(context); //cerramos la pantalla
                      } else {
                        //si se olvidó del video, le avisamos con un mensaje abajo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor, selecciona un vídeo primero")),
                        );
                      }
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          //un botón de X arriba a la derecha para cerrar sin hacer nada
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  //esto pone la imagen de fondo
  Widget _buildBackground() {
    return SizedBox.expand(
      child: Image.asset(
        "assets/Fondo.png",
        fit: BoxFit.cover,
        //si la imagen falla o no existe, ponemos un fondo negro para que no explote
        errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
      ),
    );
  }

  //esto pone el logo con una animación suave
  Widget _buildHeaderSimple() {
    return Hero(
      tag: 'logo_principal',
      child: Image.asset("assets/logo.png", width: 150, height: 150),
    );
  }

  //una caja gris redondeada para meter los textos dentro
  Widget _buildFormContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF262626).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  //esta pieza crea una caja de texto donde el usuario puede escribir
  Widget _buildTextField(String hint, {required TextEditingController controller}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint, //el texto gris que dice qué hay que escribir
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF444444).withOpacity(0.7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  //esta pieza crea los botones grandes de colores
  Widget _buildButton(String texto, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap, //lo que pasa cuando lo pulsas
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}