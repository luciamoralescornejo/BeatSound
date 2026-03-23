import 'package:flutter/material.dart';
import 'video_card.dart';

//usamos StatelessWidget porque esta pantalla solo sirve para dibujar la lista de videos, no cambia nada
// internamente por sí sola
class PantallaNovedades extends StatelessWidget {
  const PantallaNovedades({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold es la estructura básica de la pantalla
    return Scaffold(
      backgroundColor: Colors.black, //ponemos el fondo negro para que combinen los videos

      //con builder, en lugar de crear 20 videos de golpe,
      // los va fabricando a medida que el usuario desliza el dedo
      body: PageView.builder(
        //indicamos que el movimiento sea vertical
        scrollDirection: Axis.vertical,

        //le decimos cuántos elementos queremos crear
        itemCount: 20,

        //itemBuilder es la instrucción de qué debe fabricar cada vez
        //index es un contador
        itemBuilder: (context, index) {
          //por cada número del contador, devolvemos una VideoCard
          return VideoCard(
            rutaArchivo: "", //aquí iría la dirección del video (por ahora está vacía)

            //usamos el símbolo $ para meter el número del contador en el texto
            //así el primero dirá Nuevo Artista #0, el segundo #1...
            artista: "Nuevo Artista #$index",

            estilo: "Recién subido",
          );
        },
      ),
    );
  }
}