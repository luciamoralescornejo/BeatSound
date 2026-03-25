import 'package:flutter/material.dart';

// usamos StatefulWidget porque esta pantalla cambia
//si dejamos de seguir a alguien, la lista se tiene que actualizar al instante
class PerfilOyente extends StatefulWidget {
  const PerfilOyente({super.key});

  @override
  State<PerfilOyente> createState() => _PerfilOyenteState();
}

class _PerfilOyenteState extends State<PerfilOyente> {
  //lListas de mapas para simular la base de datos
  List<Map<String, String>> siguiendo = [
    {"nombre": "@artista1", "genero": "Reggaeton"},
    {"nombre": "@artista2", "genero": "Trap"},
    {"nombre": "@artista4", "genero": "Techno"},
  ];

  List<Map<String, String>> bloqueados = [
    {"nombre": "@artista3", "genero": "Pop"},
  ];

  //función para dejar de seguir: busca al artista por su posición y lo borra de la lista
  void _dejarDeSeguir(int index) {
    String nombre = siguiendo[index]["nombre"]!;
    setState(() => siguiendo.removeAt(index)); //setState le dice a Flutter que dibuje la pantalla otra vez
    _mostrarMensaje("Has dejado de seguir a $nombre");
  }

  //hace lo mismo pero en la lista de bloqueados
  void _desbloquear(int index) {
    String nombre = bloqueados[index]["nombre"]!;
    setState(() => bloqueados.removeAt(index));
    _mostrarMensaje("$nombre ha sido desbloqueado");
  }

  //función para mostrar el aviso flotante (SnackBar) que ya conoces
  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack( //usamos Stack para poner las luces de colores al fondo y el texto encima
        children: [
          //luz neón arriba a la izquierda
          Positioned(
            top: -50,
            left: -50,
            child: _buildNeonGlow(const Color(0xFF2962FF).withOpacity(0.12), 350),
          ),
          //luz neón abajo a la derecha
          Positioned(
            bottom: 100,
            right: -80,
            child: _buildNeonGlow(const Color(0xFF4D6CFF).withOpacity(0.08), 400),
          ),

          SafeArea(
            child: SingleChildScrollView( //permite hacer scroll si la lista de artistas es muy larga
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Center(child: _buildAvatarConLuz()), //el círculo de la foto de perfil
                  const SizedBox(height: 15),
                  const Text("@usuario_beatsound",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  const Text("Oyente Premium",
                      style: TextStyle(color: Colors.white38, fontSize: 14)),

                  const SizedBox(height: 35),
                  _buildSeccionTitulo(Icons.headphones_rounded, "Siguiendo (${siguiendo.length})"),

                  //... es el operador Spread que sirve para soltar todos los elementos de la lista dentro de la columna
                  ...siguiendo.asMap().entries.map((entry) {
                    return _itemUsuarioGlass(
                      nombre: entry.value["nombre"]!,
                      subtitulo: entry.value["genero"]!,
                      iconoAccion: Icons.person_remove_rounded,
                      colorIcono: Colors.white60,
                      onTapAccion: () => _dejarDeSeguir(entry.key), //le pasamos la posición para saber a quién borrar
                    );
                  }).toList(),

                  const SizedBox(height: 30),

                  _buildSeccionTitulo(Icons.block_flipped, "Bloqueados (${bloqueados.length})"),

                  ...bloqueados.asMap().entries.map((entry) {
                    return _itemUsuarioGlass(
                      nombre: entry.value["nombre"]!,
                      subtitulo: entry.value["genero"]!,
                      esBloqueado: true, //esto cambia el icono por un botón de desbloquear
                      onTapAccion: () => _desbloquear(entry.key),
                    );
                  }).toList(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //crea el efecto de brillo neón circular de fondo
  Widget _buildNeonGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 40)],
      ),
    );
  }

  //reca el avatar con un borde iluminado
  Widget _buildAvatarConLuz() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [const Color(0xFF2962FF), const Color(0xFF2962FF).withOpacity(0.1)],
        ),
      ),
      child: const CircleAvatar(
        radius: 65,
        backgroundColor: Colors.black,
        child: CircleAvatar(
          radius: 62,
          backgroundImage: NetworkImage("https://picsum.photos/300"), //foto de perfil de internet hasta que registremos los datos seleccionados
        ),
      ),
    );
  }

  //crea los títulos de las secciones (siguiendo y bloqueados)
  Widget _buildSeccionTitulo(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF2962FF), size: 18),
          const SizedBox(width: 10),
          Text(texto.toUpperCase(),
            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }

  //es el diseño de cada fila con efecto cristal (Glassmorphism)
  Widget _itemUsuarioGlass({
    required String nombre,
    required String subtitulo,
    IconData? iconoAccion,
    Color? colorIcono,
    bool esBloqueado = false,
    required VoidCallback onTapAccion,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF262626).withOpacity(0.4), //fondo semitransparente
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)), //borde muy fino
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: CircleAvatar( //la fotito del artista
          backgroundColor: Colors.white10,
          backgroundImage: NetworkImage("https://picsum.photos/id/${nombre.length + 20}/150"),
        ),
        title: Text(nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitulo, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        //al final de la fila, ponemos o un icono o un botón de desbloquear
        trailing: esBloqueado
            ? TextButton(
          onPressed: onTapAccion,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF2962FF).withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text("DESBLOQUEAR", style: TextStyle(color: Color(0xFF2962FF), fontSize: 10, fontWeight: FontWeight.bold)),
        )
            : IconButton(
          onPressed: onTapAccion,
          icon: Icon(iconoAccion, color: colorIcono, size: 22),
        ),
      ),
    );
  }
}