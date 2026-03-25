import 'package:flutter/material.dart';
import 'publicar_video.dart';

class PerfilArtista extends StatelessWidget {
  //'esArtista' es un booleano, nos dirá si debemos mostrar el botón de añadir video o no
  final bool esArtista;

  const PerfilArtista({super.key, required this.esArtista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack( //usamos Stack para las capas, primero el fondo de neón, luego el contenido
        children: [
          //capas de luces neones colocadas en esquinas opuestas
          Positioned(
            top: -100,
            right: -50,
            child: _buildNeonGlow(const Color(0xFF2962FF).withOpacity(0.15), 300),
          ),
          Positioned(
            bottom: -150,
            left: -50,
            child: _buildNeonGlow(const Color(0xFF4D6CFF).withOpacity(0.1), 400),
          ),

          Column(
            children: [
              const SizedBox(height: 60), //espacio para que el perfil no choque con la cámara

              //foto circular con borde brillante
              _buildProfileHeader(),
              const SizedBox(height: 15),

              const Text("DJ TECH MASTER",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const Text("@djtech_official",
                  style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w500)),

              const SizedBox(height: 25),

              //cuadro con seguidores y likes
              _buildStatsCard(),
              const SizedBox(height: 10),

              _buildProfileTabs(), //espacio preparado para futuras pestañas

              //una rejilla tipo Instagram
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  //SliverGridDelegate define que queremos 3 columnas fijas
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8, //espacio horizontal entre cuadros
                    mainAxisSpacing: 8,  //espacio vertical entre cuadros
                    childAspectRatio: 0.75, //hace que los cuadros sean un poco más altos que anchos
                  ),
                  itemCount: 12, //simulamos que el artista tiene 12 videos
                  itemBuilder: (context, index) => _buildVideoThumbnail(index),
                ),
              ),
            ],
          ),
        ],
      ),

      //si esArtista es true, aparece el botón +. Si es false, no aparece nada
      floatingActionButton: esArtista
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF2962FF),
        elevation: 10,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
        //al tocarlo nos empuja (push) a la pantalla de PublicarVideo
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PublicarVideo()),
        ),
      )
          : null,
    );
  }

  //crea el efecto de resplandor neón circular
  Widget _buildNeonGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }

  //construye la foto de perfil con un degradado
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFF2962FF), Color(0xFF4D6CFF)]),
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.black,
        child: ClipOval(
          child: Image.network(
            "https://picsum.photos/200",
            fit: BoxFit.cover,
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }

  //crea la tarjeta de estadisticas
  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF262626).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(label: "Seguidores", value: "12.5k"),
          //el Divider es la rayita vertical que separa los números
          VerticalDivider(color: Colors.white24, indent: 10, endIndent: 10),
          _StatItem(label: "Likes", value: "45.2k"),
        ],
      ),
    );
  }

  //crea cada miniatura del video en la rejilla
  Widget _buildVideoThumbnail(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          //cambiamos la foto según el índice para que no sean todas iguales
          image: NetworkImage("https://picsum.photos/id/${index + 100}/300/400"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          //ponemos el número de reproducciones en una esquinita blanca abajo
          Positioned(
            bottom: 8,
            left: 8,
            child: Row(
              children: [
                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                Text(
                  "${(index + 1) * 2}k", //simula visualizaciones crecientes
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabs() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}

//pequeño molde para las estadísticas
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 0.5)),
      ],
    );
  }
}