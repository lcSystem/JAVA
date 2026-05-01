class Publicacion {
  final int id;
  final String titulo;
  final String contenido;
  final int usuarioId;

  Publicacion({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.usuarioId,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      titulo: json['title'],
      contenido: json['body'],
      usuarioId: json['userId'],
    );
  }
}
